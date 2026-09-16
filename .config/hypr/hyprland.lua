-- ~/.config/hypr/hyprland.lua

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "vicinae toggle"
local browser     = "firefox"
local mainMod     = "SUPER"

-- Monitor
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-- Environment
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- WLR_NO_HARDWARE_CURSORS=1 replacement
hl.config({
    cursor = {
        no_hardware_cursors = 1,
    },

    general = {
        gaps_in = 4,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        col = {
            active_border = {
                colors = {
                    "rgba(7dd3fbee)",
                    "rgba(f472b6ee)",
                },
                angle = 35,
            },
            inactive_border = "rgba(303846aa)",
        },
    },

    decoration = {
        rounding = 12,
        rounding_power = 2,
        active_opacity = 0.98,
        inactive_opacity = 0.86,

        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            color = "rgba(02061755)",
        },

        blur = {
            enabled = true,
            size = 7,
            passes = 2,
            vibrancy = 0.18,
            ignore_opacity = true,
        },
    },

    input = {
        follow_mouse = 0,
        touchpad = {
            natural_scroll = false,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        focus_on_activate = true,
    },
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("pidof hypridle >/dev/null || hypridle")
    hl.exec_cmd("vicinae server")
end)

-- Animations
hl.curve("easeOutQuint", {
    type = "bezier",
    points = {
        { 0.23, 1 },
        { 0.32, 1 },
    },
})

hl.curve("linear", {
    type = "bezier",
    points = {
        { 0, 0 },
        { 1, 1 },
    },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = {
        { 0.5, 0.5 },
        { 0.75, 1 },
    },
})

hl.curve("quick", {
    type = "bezier",
    points = {
        { 0.15, 0 },
        { 0.1, 1 },
    },
})

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    bezier = "easeOutQuint",
    style = "popin 87%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick",
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})

hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 7,
    bezier = "quick",
})

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- ============================================================
-- Keybinds
-- ============================================================

-- macOS-like Command shortcuts. Hyprland owns SUPER, so translate the common
-- app shortcuts to their Linux Ctrl equivalents.
local ctrlKeys = {
    "A", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
    "N", "O", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
}

for _, key in ipairs(ctrlKeys) do
    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.send_shortcut({
            mods = "CTRL",
            key = key,
        }),
        { repeating = true }
    )
end

-- macOS-style redo
hl.bind(
    mainMod .. " + SHIFT + Z",
    hl.dsp.send_shortcut({
        mods = "CTRL",
        key = "Y",
    }),
    { repeating = true }
)

-- Applications / window management
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close({}))
hl.bind(mainMod .. " + M", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.focus({ workspace = "special:minimized" }))
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- macOS-style text navigation in GUI apps
hl.bind(mainMod .. " + left", hl.dsp.send_shortcut({ mods = "", key = "HOME" }), { repeating = true })
hl.bind(mainMod .. " + right", hl.dsp.send_shortcut({ mods = "", key = "END" }), { repeating = true })
hl.bind(mainMod .. " + up", hl.dsp.send_shortcut({ mods = "CTRL", key = "HOME" }), { repeating = true })
hl.bind(mainMod .. " + down", hl.dsp.send_shortcut({ mods = "CTRL", key = "END" }), { repeating = true })

-- Window focus, moved off the plain Command-arrow muscle memory
hl.bind(mainMod .. " + ALT + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.focus({ direction = "d" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = tostring(i) })
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = tostring(i),
            follow = true,
        })
    )
end

-- Workspace navigation
hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)

hl.bind(
    mainMod .. " + TAB",
    hl.dsp.focus({ workspace = "previous" })
)

-- Mouse window movement
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

-- ============================================================
-- Media / hardware keys
-- ============================================================

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

-- ============================================================
-- Window rules
-- ============================================================

-- Ignore application maximize requests
hl.window_rule({
    name = "suppress-maximize",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

-- XWayland drag workaround
hl.window_rule({
    name = "fix-xwayland-dragging",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_initial_focus = true,
})

-- Keep utility dialogs light and Mac-like.
hl.window_rule({
    name = "float-audio-settings",
    match = {
        class = "pavucontrol",
    },
    float = true,
    center = true,
    size = { 900, 640 },
})

hl.window_rule({
    name = "float-bluetooth-manager",
    match = {
        class = "blueman-manager",
    },
    float = true,
    center = true,
    size = { 900, 640 },
})

hl.window_rule({
    name = "float-file-chooser",
    match = {
        title = ".*(Open|Save|Choose|Select).*",
    },
    float = true,
    center = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = {
        title = ".*[Pp]icture.*[Pp]icture.*",
    },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
})

-- ============================================================
-- Vicinae
-- ============================================================

hl.layer_rule({
    name = "vicinae",
    match = {
        namespace = "vicinae",
    },
    blur = true,
    ignore_alpha = 0,
    no_anim = true,
})
