-- Hyprland
hl.env("HYPRLAND_TRACE", "1")
hl.env("HYPRLAND_NO_RT", "1")
hl.env("HYPRLAND_NO_SD_NOTIFY", "1")
hl.env("HYPRLAND_NO_SD_VARS", "1")

-- Toolkit Backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Cursor
-- Needs to be installed, guide on https://blog.nicoandres.dev/change-your-cursor-in-arch-hyprland/
-- 1. git clone https://gitlab.com/Pummelfisch/future-cyan-hyprcursor.git ~/.config/future-cyan
-- 2. cp ~/.config/future-cyan/Future-Cyan-Hyprcursor_Theme ~/.local/share/icons/Future-Cyan
hl.env("XCURSOR_THEME", "Future-Cyan")
hl.env("XCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_THEME", "Future-Cyan")
hl.env("HYPRCURSOR_SIZE", "36")

-- Nvidia
-- These are the standard Nvidia options. However, to let the GPU go into D3Cold with optimus, these are not preferred
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Set the order for which graphics devices aquamarine uses
hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu")

-- Stop hyprpaper form hogging dGPU. May prevent nvidia module unloading
hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json")
