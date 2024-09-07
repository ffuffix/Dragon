<div align="center">
 <img alt="Dragon" src="https://github.com/ffuffix/Dragon/blob/cebe941da6a746775238b12919b147b96c2d7a5d/Project/Images/Dragon_1.png">
</div>

### About
I made this since it helps to jump into data saving & loading really fast with just a few lines of code.

## Quickstart
To access Dragon put the Module inside of a place where you can easily find it
Next require it and Init with your own arguments!
```luau
local Dragon = require("path.to.dragon")
local D = Dragon.DataStore("DataStore")

D:Init({ Scope = "V1" }) -- Optional table with scope argument
```
Now you can start getting and manipulating data
```luau
local Data = D:Get("Runs"):Now():GetData() or 0 -- 0 if data doesn't exist

print(Data) --> 0 or above if ran multiple times

D:Set("Runs", Data + 1):Now()
```


> [!NOTE]
> This has not been tested on large experiences and may fail even though it's designed to not to


This is my first public project so please give me advice on what I can improve on!
