------------------
-- MY THEMEEEEE --
------------------

-- << LIBRARIES >>
-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")

-- widgets and layout
local wibox = require("wibox") 
local lain = require("lain")

-- window sizing mostly
local xresources = require("beautiful.xresources")
----------------------------------------------------

local math, string, tag, tonumber, type, os = math, string, tag, tonumber, type, os
local dpi = xresources.apply_dpi
local my_table = gears.table

-- create theme obj (table)
local theme = {}

-- wallpapers
local wall = {
	"monsters.png",
	"onepiece.png",
	"sunrise.jpg",
	"island.png"
}

theme.dir 				= os.getenv("HOME") .. "/.config/awesome/themes/waq/"
theme.default_dir       = require("awful.util").get_themes_dir() .. "default"
theme.wallpaper 		= theme.dir .. wall[1]
theme.font 				= "Source Code Pro 10"
theme.taglist_font 		= theme.font

-- << COLOURS >>
-- foreground
theme.fg_normal 		= "#9171AD"
theme.fg_focus 			= "#F9C784"
theme.fg_urgent 		= "#F59C29"

-- background
theme.bg_normal 		= "#141414"
theme.bg_focus 			= theme.bg_normal
theme.bg_urgent			= "#0F060D"

-- window borders
theme.border_normal     = "#0E0E0E"
theme.border_focus      = "#CD4631"

-- taglist
theme.taglist_fg_focus  = theme.fg_focus
theme.taglist_bg_focus 	= theme.bg_focus

-- tasklist
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_bg_focus	= theme.bg_focus

-- << DIMENSIONS >>
theme.border_width	= dpi(1)
theme.menu_height 	= dpi(16)
theme.menu_width    = dpi(130)
theme.useless_gap 	= dpi(4)

-- tasklist misc
theme.tasklist_plain_task_name		= true
theme.tasklist_disable_icon			= false
theme.tasklist_disable_task_name	= true

-- << ICONS >>
local icons = {} -- create icons table
icons.dir 		= os.getenv("HOME") .. "/.config/awesome/icons/"
icons.close 	= icons.dir .. "solid/times.svg"
icons.maximize 	= icons.dir .. "solid/expand.svg"
icons.maximize2	= icons.dir .. "solid/compress.svg"
icons.minimize 	= icons.dir .. "solid/minus.svg"

-- << TITLEBAR ICONS & BG >>
theme.icon_normal	= theme.fg_normal
theme.icon_focus	= theme.fg_focus
theme.icon_hover	= theme.fg_urgent
theme.icon_pressed	= "#CD4631"
recol = gears.color.recolor_image

-- close
theme.titlebar_close_button_normal			= recol(icons.close, theme.icon_normal)
theme.titlebar_close_button_normal_hover	= recol(icons.close, theme.icon_hover)
theme.titlebar_close_button_normal_pressed	= recol(icons.close, theme.icon_pressed)	

theme.titlebar_close_button_focus			= recol(icons.close, theme.icon_normal)
theme.titlebar_close_button_focus_hover		= recol(icons.close, theme.icon_hover)
theme.titlebar_close_button_focus_pressed	= recol(icons.close, theme.icon_pressed)	

-- maximize
theme.titlebar_maximized_button_normal_active 		= recol(icons.maximize, theme.icon_normal)
theme.titlebar_maximized_button_normal_active_hover	= recol(icons.maximize, theme.icon_hover)	
theme.titlebar_maximized_button_normal_active_press	= recol(icons.maximize, theme.icon_pressed)

theme.titlebar_maximized_button_focus_inactive 			= recol(icons.maximize2, theme.icon_normal)	
theme.titlebar_maximized_button_focus_inactive_hover	= recol(icons.maximize2, theme.icon_hover)
theme.titlebar_maximized_button_focus_inactive_press	= recol(icons.maximize2, theme.icon_pressed)

-- minimize
theme.titlebar_minimize_button_normal		= recol(icons.minimize, theme.icon_normal)
theme.titlebar_minimize_button_normal_hover	= recol(icons.minimize, theme.icon_hover)
theme.titlebar_minimize_button_normal_press	= recol(icons.minimize, theme.icon_pressed)

theme.titlebar_minimize_button_focus		= recol(icons.minimize, theme.icon_normal)
theme.titlebar_minimize_button_focus_hover	= recol(icons.minimize, theme.icon_hover)
theme.titlebar_minimize_button_focus_press	= recol(icons.minimize, theme.icon_pressed)

-- titlebar background
local barheight = dpi(18)
local barcolor  = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.bg_focus }, {0.8, theme.border_normal}, {1, "#1A1A1A"} }
})

local barcolor2 = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.bg_focus}, {0.5, theme.border_focus}, {1, "#492417"} }
})
theme.titlebar_bg = barcolor
theme.titlebar_bg_focus = barcolor2

-- layout icons
theme.layout_tile       = theme.default_dir.."/layouts/tilew.png"
theme.layout_floating   = theme.default_dir.."/layouts/floatingw.png"

-- << WIDGETS >>
local markup = lain.util.markup
local textCol = "#EBEBEB"

-- Battery
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

-- Brightness
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")

-- Calendar
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- Textclock
local mytextclock = wibox.widget.textclock("%a.%b.%d | %I:%M %p")
mytextclock.font = theme.font

local cw = calendar_widget()
mytextclock:connect_signal("button::press", 
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end
)

-- Github
-- local github_activity_widget = require("awesome-wm-widgets.github-activity-widget.github-activity-widget")

-- Spotify
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")

-- Volume Bar
local volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")

-- Launcher
local mylauncher = awful.widget.button({image = theme.awesome_icon})
mylauncher:connect_signal("button::press", function() awful.util.mymainmenu:toggle() end)

-- < SEPARATORS >>
local space = wibox.widget.textbox(" ")
local rspace1 = wibox.widget.textbox()
local rspace0 = wibox.widget.textbox()
local rspace2 = wibox.widget.textbox()
local rspace3 = wibox.widget.textbox()
local tspace1 = wibox.widget.textbox()
tspace1.forced_width = dpi(18)
rspace1.forced_width = dpi(16)
rspace0.forced_width = dpi(18)
rspace2.forced_width = dpi(19)
rspace3.forced_width = dpi(21)

local lspace1 = wibox.widget.textbox()
local lspace2 = wibox.widget.textbox()
local lspace3 = wibox.widget.textbox()
lspace1.forced_height = dpi(18)
lspace2.forced_height = dpi(10)
lspace3.forced_height = dpi(16)

-- << TAGLIST >>
awful.util.tagnames = { "1", "2", "3"}

theme.makeTagList = function(s)
    local tags = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
            shape = gears.shape.rectangle
        },
        layout   = {
            spacing = -12,
            spacing_widget = {
                color  = '#dddddd',
                shape  = gears.shape.rectangle,
                widget = wibox.widget.separator,
            },
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id     = 'index_role',
                                widget = wibox.widget.textbox,
                            },
                            margins = 4,
                            widget  = wibox.container.margin,
                        },
                        bg     = '#dddddd',
                        shape  = gears.shape.circle,
                        widget = wibox.container.background,
                    },
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 18,
                right = 18,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,

            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#ff0000' then
                        self.backup     = self.bg
                        self.has_backup = true
                    end
                    self.bg = '#ff0000'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            end,
        },
        buttons = taglist_buttons
    }
    return tags
end

local dockshape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 6)
end

-- << VERTICAL WIBOX >> 
function theme.vertical_wibox(s)
    -- Create the vertical wibox
    s.dockheight = (35 *  s.workarea.height)/100

    s.myleftwibox = wibox({ screen = s, x=0, y=s.workarea.height/2 - s.dockheight/2, width = dpi(6), height = s.dockheight, fg = theme.fg_normal, bg = barcolor2, ontop = true, visible = true, type = "dock" })

    if s.index > 1 and s.myleftwibox.y == 0 then
        s.myleftwibox.y = screen[1].myleftwibox.y
    end

    -- Add widgets to the vertical wibox
    s.myleftwibox:setup {
        layout = wibox.layout.align.vertical,
        {
            layout = wibox.layout.fixed.vertical,
            lspace1,
            lspace2,
            s.layoutb,
            wibox.container.margin(mylauncher, dpi(5), dpi(8), dpi(13), dpi(0)),
        },
    }

    -- Add toggling functionalities
    s.docktimer = gears.timer{ timeout = 2 }
    s.docktimer:connect_signal("timeout", function()
        local s = awful.screen.focused()
        s.myleftwibox.width = dpi(9)
        s.layoutb.visible = false
        mylauncher.visible = false
        if s.docktimer.started then
            s.docktimer:stop()
        end
    end)
    tag.connect_signal("property::selected", function(t)
        local s = t.screen or awful.screen.focused()
        s.myleftwibox.width = dpi(38)
        s.layoutb.visible = true
        mylauncher.visible = true
        gears.surface.apply_shape_bounding(s.myleftwibox, dockshape)
        if not s.docktimer.started then
            s.docktimer:start()
        end
    end)

    s.myleftwibox:connect_signal("mouse::leave", function()
        local s = awful.screen.focused()
        s.myleftwibox.width = dpi(9)
        s.layoutb.visible = false
        mylauncher.visible = false
    end)

    s.myleftwibox:connect_signal("mouse::enter", function()
        local s = awful.screen.focused()
        s.myleftwibox.width = dpi(38)
        s.layoutb.visible = true
        mylauncher.visible = true
        gears.surface.apply_shape_bounding(s.myleftwibox, dockshape)
    end)
end

-- << SCREEN >>
function theme.at_screen_connect(s)
    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)
        )
    )
    s.layoutb = wibox.container.margin(s.mylayoutbox, dpi(8), dpi(11), dpi(3), dpi(3))

    -- Create a taglist widget
    s.mytaglist = theme.makeTagList(s)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { bg_normal = barcolor, bg_focus = barcolor })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = barheight, bg = barcolor })

    -- Add widgets to the wibox
    s.mywibox:setup {

        -- Layout
        layout = wibox.layout.align.horizontal,

        -- LEFT
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            space,
            s.mypromptbox,
            space,
        },

        -- MIDDLE
        s.mytasklist, -- Middle widget

        -- RIGHT
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            space,
            spotify_widget(),
            space,
            brightness_widget(),
            space,
            volumebar_widget(),
            space,
            batteryarc_widget(),
            space,
            mytextclock,
            space,
            s.mylayoutbox
        },
    }

    gears.timer.delayed_call(theme.vertical_wibox, s)
end

return theme
