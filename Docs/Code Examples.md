# Setup

```
local Dragon = require(path.to.dragon)

local D = Dragon.DataStore("Profiles")

D:Init()
```


# Basic profile structure

```
local Dragon = require(path.to.dragon)
local D = Dragon.DataStore("Profiles")

local PlayerService = game:GetService("Players")


D:Init({ Scope = "V1" }) -- Sets scope


PlayerService.PlayerAdded:Connect(function(Player: Player)
  local Profile = D:Get(Player.UserId):Now()
  print(Profile)
end)
```


# Automatic Profile Sessions
You can grab the data from Player.Profile in this code example
To change data simply do Player.Profile:SetAttribute("Shards", 1) or whatever amount you want and it will persist among different sessions
```
local Dragon = require(path.to.dragon)
local D = Dragon.DataStore("Profiles")

local PlayerService = game:GetService("Players")


D:Init({ Scope = "V1" })

D:Template({ Shards = 0 }, true)


PlayerService.PlayerAdded:Connect(function(Player: Player)

	D:Get(Player.UserId):UntilSuccess():Reconcile():CreateSession({ Player = Player }):Attributes("Profile")

end)
```
