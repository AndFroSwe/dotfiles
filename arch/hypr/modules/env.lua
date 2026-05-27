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

-- Styling
-- hl.env("XCURSOR_THEME", "rose-pine-hyprcursor")
-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
-- hl.env("HYPRCURSOR_SIZE", "24")

-- Cursor
-- Needs to be installed, guide on https://blog.nicoandres.dev/change-your-cursor-in-arch-hyprland/
-- 1. git clone https://gitlab.com/Pummelfisch/future-cyan-hyprcursor.git ~/.config/future-cyan
-- 2. cp ~/.config/future-cyan/Future-Cyan-Hyprcursor_Theme ~/.local/share/icons/Future-Cyan
hl.env("XCURSOR_THEME", "Future-Cyan")
hl.env("XCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_THEME", "Future-Cyan")
hl.env("HYPRCURSOR_SIZE", "36")
