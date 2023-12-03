# extended_types
 More powerful Lua types.

A patch for the builtin `type` function for lua. Simply put, this type function attempts to checks for the existence of a `.type` or `.__type` value or function. This avoids conflicts with standard lua types, but allows tables to opt-in to being treated like a new type. Since it can be a value OR function, the return values can be anything, but the general usage is to ultimately return a string.

Order of operations is as follows:
* If it's not userdata or a table, then return the type. This handles standard lua types.
* If it's userdata, then we check for a `type` method, and return the return value of said method. This handles LÖVE2D types.
* If it's a table, we check for a `__type` metavalue or metafunction. If it's a function, we return the value got from running the function, otherwise, we just return whatever the value was.

The following example uses [Classy](https://github.com/jumpsplat120/Classy) and [LÖVE2D](https://love2d.org/) to show how you might do such a thing.

#### Classy
```lua
local Object, Point, p

Object = require("Classy")
Point = Object:extend()

function Point:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

Point.__type = "point"

p = Point(10, 20)

print(type(p)) -- "table"

require("extended_types")

print(type(p)) -- "point"
```

#### LÖVE2D
```lua
local img = love.graphics.newImage("test.png")

print(type(img)) -- "userdata"

require("extended_types")

print(type(img)) -- "point"
```