-- micro's syntax highlighting documentation
-- https://github.com/micro-editor/micro/blob/master/runtime/help/colors.md

black = "#ffffff"
gray  = "#6f6f6f"
white = "#0f0f0f"

local colors = {
    background 	= black,
    text     	= white,
    comment  	= gray,
    keyword  	= "#cba6f7",
    string   	= "#a6e3a1",
    number   	= "#fab387",
    line-number = white,
    accent   	= "#89b4fa",
}

local groups = {
    default    	= { "text", "background" },
    comment    	= { "comment" },
    identifier 	= { "identifier "}
    constant   	= { "number" },
    ["constant.string"] = { "string" },
    statement  	= { "keyword" },
    symbol     	= {}
    preproc    	= {}
    type       	= { "accent" },
    special    	= {}
    underligned	= {}
    error       = {}
    todo        = {}
    selection   = {}
    statusline  = {}
    ["statusline.inactive"]    = {}
    ["statusline.suggestions"] = {}
    tabbar      = {}
    ["tabbar.active"] = {}
    indent-char = {}
    line-number = {}
    gutter-info    = {}
    gutter-error   = {}
    gutter-warning = {}
    diff-added    = {}
    diff-modified = {}
    diff deleted  = {}
    cursor-line 	   = {}
    cursor-line-number = {}
    color-column = {}
    ignore = {}
    scrollbar = {}
    divider = {}
    
    identifier 	= { "text" },
    symbol     	= { "accent" },
}

local home = assert(os.getenv("HOME"), "HOME is not set")
local path = home .. "/.config/micro/colorschemes/default.micro"

local file = assert(io.open(path, "w"))
for group, pair in pairs(groups) do
    local fg = colors[pair[1]]
    local bg = pair[2] and colors[pair[2]]
    local value = bg and (fg .. "," .. bg) or fg
    file:write(string.format('color-link %s "%s"\n', group, value))
end
file:close()
-- micro's syntax highlighting documentation
-- https://github.com/micro-editor/micro/blob/master/runtime/help/colors.md

black = "#ffffff"
gray  = "#6f6f6f"
white = "#0f0f0f"

local colors = {
    background 	= black,
    text     	= white,
    comment  	= gray,
    keyword  	= "#cba6f7",
    string   	= "#a6e3a1",
    number   	= "#fab387",
    line-number = white,
    accent   	= "#89b4fa",
}

local groups = {
    default    	= { "text", "background" },
    comment    	= { "comment" },
    identifier 	= { "identifier "}
    constant   	= { "number" },
    ["constant.string"] = { "string" },
    statement  	= { "keyword" },
    symbol     	= {}
    preproc    	= {}
    type       	= { "accent" },
    special    	= {}
    underligned	= {}
    error       = {}
    todo        = {}
    selection   = {}
    statusline  = {}
    ["statusline.inactive"]    = {}
    ["statusline.suggestions"] = {}
    tabbar      = {}
    ["tabbar.active"] = {}
    indent-char = {}
    line-number = {}
    gutter-info    = {}
    gutter-error   = {}
    gutter-warning = {}
    diff-added    = {}
    diff-modified = {}
    diff deleted  = {}
    cursor-line 	   = {}
    cursor-line-number = {}
    color-column = {}
    ignore = {}
    scrollbar = {}
    divider = {}
    
    identifier 	= { "text" },
    symbol     	= { "accent" },
}

local home = assert(os.getenv("HOME"), "HOME is not set")
local path = home .. "/.config/micro/colorschemes/default.micro"

local file = assert(io.open(path, "w"))
for group, pair in pairs(groups) do
    local fg = colors[pair[1]]
    local bg = pair[2] and colors[pair[2]]
    local value = bg and (fg .. "," .. bg) or fg
    file:write(string.format('color-link %s "%s"\n', group, value))
end
file:close()
