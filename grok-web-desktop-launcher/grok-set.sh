#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Requires root access to create desktop icon"
    echo "Try running sudo $0"
    exit 1
fi

FILEPATH="/usr/share/applications/grok-web.desktop"

if [ -n "$SUDO_USER" ]; then
    USERNAME="$SUDO_USER"
else
    USERNAME=$(whoami)
fi

ICON_PATH="/home/$USERNAME/grok.png"
ICON_SOURCE="./grok.png"

if [ $# -eq 1 ]; then
    ICON_SOURCE="$1"
fi

if [ ! -f "$ICON_PATH" ]; then
    if [ -f "$ICON_SOURCE" ]; then
        cp "$ICON_SOURCE" "$ICON_PATH" || {
            echo "Error: Failed to copy $ICON_SOURCE to $ICON_PATH"
            ICON_PATH="web-browser"
        }
        chown "$USERNAME:$USERNAME" "$ICON_PATH" || {
            echo "Error: Failed to set ownership of $ICON_PATH"
            ICON_PATH="web-browser"
        }
    else
        echo "Warning: Icon source $ICON_SOURCE not found."
        echo "Using default 'web-browser' icon."
        ICON_PATH="web-browser"
    fi
else
    echo "Icon already exists at $ICON_PATH, using it."
fi

cat > "$FILEPATH" << EOL
[Desktop Entry]
Name=Grok AI
Comment=Open the Grok website by xAI
Exec=xdg-open https://grok.com/
Type=Application
Terminal=false
Icon=$ICON_PATH
EOL

chmod +x "$FILEPATH"
