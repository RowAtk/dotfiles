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

local dpi = xresources.apply_dpi
local os = os
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

theme.dir 				= os.getenv("HOME") .. "/.config/awesome/themes/waq"
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
icons.dir 		= os.getenv("HOME") .. "/.config/awesome/icons"
icons.close 	= icons.dir .. "solid/times.svg"
icons.maximize 	= icons.dir .. "/solid/expand.svg"
icons.maximize2	= icons.dir .. "/solid/compress.svg"
icons.minimize 	= icons.dir .. "solid/minus.svg"

-- << TITLEBAR ICONS >>
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

-- << TAGLIST >>

-- << WIDGETS >>
local markup = lain.util.markup
local separators = lain.util.separators
local textCol = "#EBEBEB"

-- Textclock
local mytextclock = wibox.widget.textclock("%a.%b.%d | %I:%M %p")
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        bat_header = " Bat "
        bat_p      = bat_now.perc .. " "
        widget:set_markup(markup.font(theme.font, markup(textCol, bat_header) .. bat_p))
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    --togglechannel = "IEC958,3",
    settings = function()
        header = " Vol "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M "
        else
            vlevel = vlevel .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(textCol, header) .. vlevel))
    end
})

-- Weather
theme.weather = lain.widget.weather({
    city_id = 3489854, -- Kingston, Jamaica
    settings = function()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(" " .. units .. " ")
    end
})


