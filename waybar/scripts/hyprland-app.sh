
#!/bin/bash

# Get active window info from hyprctl
window_info=$(hyprctl activewindow)

# Extract appId or class field from the output (adjust depending on your hyprctl version)
app=$(echo "$window_info" | grep "appId" | awk '{print $2}' | tr -d '"')

# If appId empty, try class
if [ -z "$app" ]; then
  app=$(echo "$window_info" | grep "class" | awk '{print $2}' | tr -d '"')
fi

# Fallback if still empty
if [ -z "$app" ]; then
  echo "Unknown"
  exit 0
fi

# Optionally map common app IDs to prettier names:
case "$app" in
  kitty) app="Kitty" ;;
  alacritty) app="Terminal" ;;
  brave) app="Brave" ;;
  firefox) app="Firefox" ;;
  chromium) app="Chromium" ;;
  nvim) app="Neovim" ;;
esac

echo "$app"
