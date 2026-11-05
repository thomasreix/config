-- this is a comment

--[[
this
is
a
multiline
comment
]]

local message = "lua is awesome!" -- this is a string
local message = 'lua is awesome!' -- this is a string
local message = [[lua is awesome!]] -- this is a string
print(message)

local sides = 5
print("a pentagon has "..sides.." sides") -- concatenate with ..

local num_X = 2
local num_Y = 5
local num_A = num_X + num_Y -- addition
local num_S = num_X - num_Y -- substraction
local num_M = num_X * num_Y -- multiplication
local num_D = num_X / num_Y -- division

local temperature = 12
local chill = 20
if temperature < chill then
    print(temperature.." degrees is cold")
elseif temperature > 20 then
    print(temperature.." degrees is hot")
else
    print(temperature.." degrees is chill")
end

local timer = 0
local finished = 8
while timer < 10 do
    timer = timer + 1
    if timer == finished then
        print("finished at "..timer.." seconds")
    end
end

local height = 0
for gravity = 1, 5, 1 do
    height = height + gravity
end
print("fell "..height.." meters")

function DoMath(n)
    return n * n - n + 1
end

local n = 7
n = DoMath(n)
print("n = "..n)

local tableA = {26, 52, 78}
local index = 1
print("index "..index.." of table is "..tableA[index])
local index = 0
print("index ", index, " of table is ", tableA[index])
local lenth = #tableA
print("the table has lenth "..lenth)

local runners = {}
table.insert(runners, "Usain Bolt")
table.insert(runners, "Yohan Blake")
table.insert(runners, "Tyson Gay")

local scores = {9.58, 9.692, 9.698}
for i, score in ipairs(scores) do
    local runner = runners[i]
    print(runner.." ran 100 meters in "..score.." seconds")
end

print("the winner is "..runners[1])

_G.GlobalVariable = 7

local num = 20
local str = tostring(num)
print(type(num), type(str))

