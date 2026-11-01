local mainMod = "SUPER"

hl.bind(mainMod.." + F1",	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod.." + Return",	 hl.dsp.exec_cmd("foot"))
hl.bind(mainMod.." + Backspace", hl.dsp.window.close())
hl.bind(mainMod.." + Space",	 hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod.." + Grave",	 hl.dsp.exec_cmd("rofi"))

hl.bind(mainMod.." + SHIFT + C", hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod.." + D", hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod.." + SHIFT + M", hl.dsp.exec_cmd("prismlauncher"))
hl.bind(mainMod.." + M", hl.dsp.exec_cmd("prismlauncher -l modern"))
hl.bind(mainMod.." + S", hl.dsp.exec_cmd("steam"))
hl.bind(mainMod.." + SHIFT + T", hl.dsp.exec_cmd("steam -applaunch 440"))
hl.bind(mainMod.." + V", hl.dsp.exec_cmd("code"))
hl.bind(mainMod.." + W", hl.dsp.exec_cmd("librewolf"))

local function flag()
    local window = hl.get_active_window()
    if window and window.class
        and window.class:lower() == "librewolf" then
        return "--new-tab"
    end
    return "--new-window"
end

hl.bind(mainMod .. " + A", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://wiki.archlinux.org/title/Main_page"))end)
hl.bind(mainMod .. " + C", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://chatgpt.com/"))end)
hl.bind(mainMod .. " + G", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://mail.google.com/"))end)
hl.bind(mainMod .. " + H", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://humanbenchmark.com/"))end)
hl.bind(mainMod .. " + T", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://mail.tutanota.com/mail/Ory-toX-1s-9"))end)
hl.bind(mainMod .. " + Y", function()hl.dispatch(hl.dsp.exec_cmd("librewolf " .. flag() .. " https://www.youtube.com/"))end)

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod.." + "..key,			hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod.." + SHIFT + "..key,	hl.dsp.window.move({ workspace = i , follow = false }))
    hl.bind(mainMod.." + ALT + "..key,	hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod.." + mouse:272",	 hl.dsp.window.drag(),	{ mouse = true })
hl.bind(mainMod.." + mouse:273",	 hl.dsp.window.resize(),	{ mouse = true })
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod.." + right",         hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod.." + left",          hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod.." + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod.." + SHIFT + left",  hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + ALT + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod.." + CTRL + left",	 hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod.." + CTRL + right",	 hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod.." + CTRL + up",	 hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod.." + CTRL + down",	 hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod.." + up",      hl.dsp.layout("orientationnext"))
hl.bind(mainMod.." + down",      hl.dsp.layout("orientationprev"))

hl.bind("Print", hl.dsp.exec_cmd([[grim "$HOME/screenshots/$(date +%d-%m-%y_%H-%M-%S).png"]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$HOME/screenshots/$(date +%d-%m-%y_%H-%M-%S).png"]]))
hl.bind("CTRL + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" "$HOME/screenshots/$(date +%d-%m-%y_%H-%M-%S).png"]]))

