#!/bin/bash
if pgrep -f "music_widget.py" >/dev/null 2>&1; then
    pkill -f "music_widget.py"
else
    python3 "$HOME/.config/music_widget/music_widget.py" >/dev/null 2>&1 &
fi
