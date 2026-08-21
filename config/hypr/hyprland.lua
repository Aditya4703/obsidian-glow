-- ╔══════════════════════════════════════════════════════════╗
-- ║            OBSIDIAN GLOW — Hyprland Config              ║
-- ║         A dark, minimal, violet/cyan rice               ║
-- ╚══════════════════════════════════════════════════════════╝


-- ┌──────────────────────────────────────────────────────────┐
-- │                      MONITORS                           │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local monitors_conf = os.getenv("HOME") .. "/.config/hypr/monitors.conf"
local f = io.open(monitors_conf, "r")
local has_monitors = false
if f then
    for line in f:lines() do
        if line:match("^monitor=") then
            local output, mode, pos, scale = line:match("^monitor=([^,]+),([^,]+),([^,]+),([^,]+)")
            if output then
                hl.monitor({ output = output, mode = mode, position = pos, scale = scale })
                has_monitors = true
            end
        end
    end
    f:close()
end

if not has_monitors then
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })
end


-- ┌──────────────────────────────────────────────────────────┐
-- │                     MY PROGRAMS                         │
-- └──────────────────────────────────────────────────────────┘

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "hyprlauncher"


-- ┌──────────────────────────────────────────────────────────┐
-- │                      AUTOSTART                          │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Wallpaper daemon (waypaper gui restore)
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 0.5 && waypaper --restore")

    -- Applets
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")

    -- Status bar
    hl.exec_cmd("waybar")

    -- Idle management
    hl.exec_cmd("hypridle")

    -- Notifications
    hl.exec_cmd("dunst")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Authentication agent
    hl.exec_cmd("hyprpolkitagent")
end)


-- ┌──────────────────────────────────────────────────────────┐
-- │                 ENVIRONMENT VARIABLES                   │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Dark theme enforcement
hl.env("GTK_THEME", "Adwaita:dark")


-- ┌──────────────────────────────────────────────────────────┐
-- │                     PERMISSIONS                         │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")


-- ┌──────────────────────────────────────────────────────────┐
-- │                    LOOK AND FEEL                        │
-- └──────────────────────────────────────────────────────────┘
-- Obsidian Glow palette:
--   Background:     #0d0d0d
--   Surface:        #1a1a2e
--   Surface 2:      #16213e
--   Accent violet:  #a855f7
--   Accent cyan:    #06b6d4
--   Text:           #e4e4e7
--   Text dim:       #a1a1aa
--   Urgent:         #f43f5e
--   Success:        #10b981
--   Warning:        #f59e0b

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 12,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(a855f7ee)", "rgba(06b6d4ee)"}, angle = 135 },
            inactive_border = "rgba(2a2a3e55)",
        },

        -- Resize windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,

        layout = "dwindle",

        -- Snapping
        snap = {
            enabled = true,
        },
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        -- Window transparency
        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        -- Dim unfocused windows slightly
        dim_inactive = true,
        dim_strength = 0.12,

        shadow = {
            enabled      = true,
            range        = 25,
            render_power = 3,
            color        = 0x66000000,
        },

        blur = {
            enabled   = true,
            size      = 8,
            passes    = 3,
            noise     = 0.01,
            contrast  = 0.9,
            brightness = 0.8,
            vibrancy  = 0.2,
            popups    = true,
        },
    },

    animations = {
        enabled = true,
    },
})


-- ┌──────────────────────────────────────────────────────────┐
-- │                     ANIMATIONS                          │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- Custom curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05}  } })
hl.curve("smoothOut",      { type = "bezier", points = { {0.36, 0},    {0.04, 1}    } })
hl.curve("smoothIn",       { type = "bezier", points = { {0.25, 1},    {0.5, 1}     } })

-- Springs
hl.curve("snappy",         { type = "spring", mass = 1, stiffness = 170, dampening = 18 })
hl.curve("gentle",         { type = "spring", mass = 1, stiffness = 80,  dampening = 14 })

-- Animation assignments
hl.animation({ leaf = "global",        enabled = true, speed = 5,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 4.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4,    spring = "snappy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,    spring = "snappy",       style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.5,  bezier = "smoothOut",    style = "popin 80%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2,    bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.5,  bezier = "smoothOut" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3,    bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3.5,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,    bezier = "smoothIn" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5,  bezier = "smoothOut" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 3,    bezier = "almostLinear", style = "slidefade 20%" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3,    bezier = "almostLinear", style = "slidefade 20%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3,    bezier = "almostLinear", style = "slidefade 20%" })


-- ┌──────────────────────────────────────────────────────────┐
-- │                       LAYOUTS                           │
-- └──────────────────────────────────────────────────────────┘

-- Dwindle — https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        preserve_split = true,
        smart_split    = true,
    },
})

-- Master — https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status = "master",
    },
})

-- Scrolling — https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


-- ┌──────────────────────────────────────────────────────────┐
-- │                        MISC                             │
-- └──────────────────────────────────────────────────────────┘

hl.config({
    misc = {
        force_default_wallpaper = 0,     -- Disable anime wallpaper (we use awww)
        disable_hyprland_logo   = true,  -- Clean background
        mouse_move_enables_dpms = true,  -- Wake on mouse move
        animate_manual_resizes  = true,  -- Smooth manual resize
    },
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


-- ┌──────────────────────────────────────────────────────────┐
-- │                        INPUT                            │
-- └──────────────────────────────────────────────────────────┘

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 to 1.0, 0 = no modification

        touchpad = {
            natural_scroll        = true,   -- Reverse (natural) scrolling
            tap_to_click          = true,
            disable_while_typing  = true,
            drag_lock             = false,
        },
    },
})

-- Gestures
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.gesture({
    fingers   = 4,
    direction = "up",
    action    = function() hl.exec_cmd(menu) end,
})

-- Cursor behavior
hl.config({
    cursor = {
        hide_on_key_press      = true,
        inactive_timeout       = 5,
    },
})


-- ┌──────────────────────────────────────────────────────────┐
-- │                     KEYBINDINGS                         │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

-- ── Core ──────────────────────────────────────────────────
hl.bind(mainMod .. " + Q",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",     hl.dsp.window.close())
hl.bind(mainMod .. " + M",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",     hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F",     hl.dsp.window.fullscreen())

-- ── Yazi (terminal file manager) ──────────────────────────
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(terminal .. " -e yazi"))

-- ── Lock screen ───────────────────────────────────────────
hl.bind(mainMod .. " + L",     hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

-- ── Screenshots (grim + slurp) ────────────────────────────
-- Region screenshot → clipboard
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
-- Fullscreen screenshot → file
hl.bind("Print",                    hl.dsp.exec_cmd('grim ~/Pictures/Screenshots/$(date +"%Y%m%d_%H%M%S").png'))
-- Region screenshot → file
hl.bind(mainMod .. " + Print",     hl.dsp.exec_cmd('grim -g "$(slurp -d)" ~/Pictures/Screenshots/$(date +"%Y%m%d_%H%M%S").png'))

-- ── Color picker ──────────────────────────────────────────
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- ── Clipboard history ─────────────────────────────────────
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | hyprlauncher --dmenu | cliphist decode | wl-copy"))

-- ── Music Widget (Now Playing) ──────────────────────────────
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/music_widget/toggle_music.sh"))

-- ── Move focus with mainMod + arrow keys ──────────────────
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- ── Move focus with mainMod + HJKL (vim-style) ───────────
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
-- SUPER+L is lock screen, so use SUPER+semicolon for right
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))

-- ── Move windows with mainMod + SHIFT + arrow keys ───────
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- ── Switch workspaces with mainMod + [0-9] ───────────────
-- ── Move window to workspace with mainMod + SHIFT + [0-9] ─
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- ── Special workspace (scratchpad) ────────────────────────
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ── Scroll through workspaces ─────────────────────────────
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- ── Move/resize windows with mouse ───────────────────────
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Resize submap (SUPER + ALT + R → enter resize mode) ──
hl.bind(mainMod .. " + ALT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.window.resize({ x = 30,  y = 0,  relative = true }), { repeating = true })
    hl.bind("left",   hl.dsp.window.resize({ x = -30, y = 0,  relative = true }), { repeating = true })
    hl.bind("up",     hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
    hl.bind("down",   hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- ── Media / hardware keys ─────────────────────────────────
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                    { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


-- ┌──────────────────────────────────────────────────────────┐
-- │                 WINDOWS AND WORKSPACES                  │
-- └──────────────────────────────────────────────────────────┘
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Suppress maximize events from all apps
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Floating windows and popups
hl.window_rule({ match = { title = "^(Volume Control)$" }, float = true })
hl.window_rule({ match = { class = "^(bluetuith)$" }, float = true })



-- Fix XWayland drag issues
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Hyprland-run window rule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Float common dialog windows
hl.window_rule({
    name  = "float-dialogs",
    match = { title = "^(Open File|Save File|Confirm|About|Properties|Preferences).*$" },
    float = true,
    center = true,
})



-- Picture-in-Picture
hl.window_rule({
    name  = "float-pip",
    match = { title = "^Picture.in.[Pp]icture$" },
    float = true,
    pin   = true,
    size  = "480 270",
})

-- NMTUI (Network Manager)
hl.window_rule({
    name  = "float-nmtui",
    match = { class = "float-nmtui" },
    float = true,
    size  = "700 500",
    center = true,
})

-- Pavucontrol (Audio Mixer)
hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
    size  = "800 600",
    center = true,
})


-- ┌──────────────────────────────────────────────────────────┐
-- │                     LAYER RULES                         │
-- └──────────────────────────────────────────────────────────┘
-- Blur + transparency for bars and launchers

hl.layer_rule({
    name  = "blur-waybar",
    match = { namespace = "waybar" },
    blur  = true,
    ignore_alpha = 0.5,
})



hl.layer_rule({
    name  = "blur-notifications",
    match = { namespace = "dunst" },
    blur  = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "blur-launcher",
    match = { namespace = "hyprlauncher" },
    blur  = true,
    ignore_alpha = 0.3,
})
