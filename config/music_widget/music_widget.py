import gi
gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gtk, Gdk, GLib, GtkLayerShell, GdkPixbuf
import subprocess
import threading
import os
import atexit
import urllib.request

NUM_BARS = 40

CSS = """
window {
    background-color: rgba(13, 13, 13, 0.85);
    border: 1px solid rgba(168, 85, 247, 0.4);
    border-radius: 20px;
}
.cover {
    border-radius: 12px;
}
.title {
    font-size: 26px;
    font-weight: 900;
    color: #e4e4e7;
    text-shadow: 0px 2px 8px rgba(0,0,0,0.9);
}
.artist {
    font-size: 17px;
    color: #a1a1aa;
    text-shadow: 0px 2px 8px rgba(0,0,0,0.9);
}
button {
    background: transparent;
    border: none;
    border-radius: 50%;
    color: #e4e4e7;
    min-width: 50px;
    min-height: 50px;
}
button:hover {
    background: rgba(255, 255, 255, 0.15);
}
.vis-bar {
    background-image: linear-gradient(to top, rgba(168, 85, 247, 0.15), rgba(168, 85, 247, 0.5));
    border-radius: 4px;
}
"""

class VisualizerBox(Gtk.Box):
    def __init__(self):
        super().__init__(spacing=5)
        self.set_valign(Gtk.Align.END)
        self.set_halign(Gtk.Align.CENTER)
        self.set_margin_bottom(15)
        self.bars = []
        self.target_heights = [4] * NUM_BARS
        self.current_heights = [4.0] * NUM_BARS
        for _ in range(NUM_BARS):
            bar = Gtk.Box()
            bar.get_style_context().add_class("vis-bar")
            bar.set_valign(Gtk.Align.END)
            bar.set_size_request(10, 4)
            self.pack_start(bar, False, False, 0)
            self.bars.append(bar)
            
        GLib.timeout_add(16, self.animate_bars)
            
    def update_bars(self, new_bars):
        for i, val in enumerate(new_bars):
            if i < NUM_BARS:
                # val is 0-1000, max height 120px
                self.target_heights[i] = max(4, int((val / 1000.0) * 120))
                
    def animate_bars(self):
        for i in range(NUM_BARS):
            diff = self.target_heights[i] - self.current_heights[i]
            self.current_heights[i] += diff * 0.40 # Faster interpolation for punchier beats
            if abs(diff) > 0.5:
                self.bars[i].set_size_request(10, int(self.current_heights[i]))
        return True

class MusicWidget(Gtk.Window):
    def __init__(self):
        super().__init__(title="music_widget")
        
        # Configure Layer Shell
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.BOTTOM)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.BOTTOM, 40)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.NONE)
        
        # Set size
        self.set_default_size(700, 180)
        self.set_size_request(700, 180)
        self.set_resizable(False)
        
        # Transparent background setup
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)
        
        # Main Overlay
        overlay = Gtk.Overlay()
        self.add(overlay)
        
        # Premium CSS Background Visualizer
        self.vis_area = VisualizerBox()
        overlay.add(self.vis_area)
        
        # Foreground Content
        hbox = Gtk.Box(spacing=25)
        hbox.set_margin_top(25)
        hbox.set_margin_bottom(25)
        hbox.set_margin_start(30)
        hbox.set_margin_end(30)
        overlay.add_overlay(hbox)
        
        self.cover_image = Gtk.Image()
        self.cover_image.get_style_context().add_class("cover")
        hbox.pack_start(self.cover_image, False, False, 0)
        
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        vbox.set_valign(Gtk.Align.CENTER)
        hbox.pack_start(vbox, True, True, 0)
        
        self.title_label = Gtk.Label(label="No Media")
        self.title_label.set_halign(Gtk.Align.START)
        self.title_label.get_style_context().add_class("title")
        vbox.pack_start(self.title_label, False, False, 0)
        
        self.artist_label = Gtk.Label(label="Unknown Artist")
        self.artist_label.set_halign(Gtk.Align.START)
        self.artist_label.get_style_context().add_class("artist")
        vbox.pack_start(self.artist_label, False, False, 0)
        
        controls = Gtk.Box(spacing=20)
        controls.set_margin_top(15)
        vbox.pack_start(controls, False, False, 0)
        
        btn_prev = Gtk.Button.new_from_icon_name("media-skip-backward-symbolic", Gtk.IconSize.DIALOG)
        btn_prev.connect("clicked", lambda w: subprocess.run(["playerctl", "previous"]))
        controls.pack_start(btn_prev, False, False, 0)
        
        self.btn_play = Gtk.Button.new_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.DIALOG)
        self.btn_play.connect("clicked", lambda w: subprocess.run(["playerctl", "play-pause"]))
        controls.pack_start(self.btn_play, False, False, 0)
        
        btn_next = Gtk.Button.new_from_icon_name("media-skip-forward-symbolic", Gtk.IconSize.DIALOG)
        btn_next.connect("clicked", lambda w: subprocess.run(["playerctl", "next"]))
        controls.pack_start(btn_next, False, False, 0)
        
        self.setup_css()
        
        self.current_url = ""
        self._cava_proc = None
        GLib.timeout_add(1000, self.update_player)
        
        threading.Thread(target=self.cava_thread, daemon=True).start()
        atexit.register(self._cleanup)
    
    def _cleanup(self):
        """Terminate cava subprocess on exit."""
        if self._cava_proc:
            self._cava_proc.terminate()
        
    def setup_css(self):
        provider = Gtk.CssProvider()
        provider.load_from_data(CSS.encode())
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )
        
    def update_player(self):
        try:
            output = subprocess.check_output(
                ["playerctl", "metadata", "-f",
                 "{{status}}|{{title}}|{{artist}}|{{mpris:artUrl}}"],
                text=True, stderr=subprocess.DEVNULL, timeout=3
            ).strip()
            
            parts = output.split("|", 3)
            if len(parts) < 4:
                return True
            status, title, artist, url = parts
            
            self.title_label.set_text(title[:35] + "..." if len(title) > 35 else title)
            self.artist_label.set_text(artist[:35] + "..." if len(artist) > 35 else artist)
            self.btn_play.set_image(Gtk.Image.new_from_icon_name(
                "media-playback-pause-symbolic" if status == "Playing" else "media-playback-start-symbolic",
                Gtk.IconSize.DIALOG
            ))
            
            if url and url != self.current_url:
                self.current_url = url
                threading.Thread(target=self.load_image, args=(url,), daemon=True).start()
                
        except Exception:
            pass
        return True

    def load_image(self, url):
        try:
            if url.startswith("http"):
                req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
                with urllib.request.urlopen(req, timeout=5) as response:
                    data = response.read()
                loader = GdkPixbuf.PixbufLoader()
                loader.write(data)
                loader.close()
                pixbuf = loader.get_pixbuf()
            elif url.startswith("file://"):
                pixbuf = GdkPixbuf.Pixbuf.new_from_file(url[7:])
            else:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file(url)
                
            scaled = pixbuf.scale_simple(130, 130, GdkPixbuf.InterpType.BILINEAR)
            GLib.idle_add(self.cover_image.set_from_pixbuf, scaled)
        except Exception as e:
            print(f"Image load error: {e}")

    def cava_thread(self):
        cava_cmd = ["cava", "-p", os.path.expanduser("~/.config/cava/config_ags")]
        proc = subprocess.Popen(cava_cmd, stdout=subprocess.PIPE, text=True)
        self._cava_proc = proc
        
        try:
            while True:
                line = proc.stdout.readline()
                if not line: break
                
                values = line.strip().split(';')[:-1]
                try:
                    bars = [int(v) for v in values if v.isdigit()]
                    if len(bars) > 0:
                        GLib.idle_add(self.vis_area.update_bars, bars)
                except ValueError:
                    pass
        finally:
            proc.terminate()

if __name__ == "__main__":
    win = MusicWidget()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()
