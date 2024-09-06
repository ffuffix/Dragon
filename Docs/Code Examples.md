# Setup

-
local Dragon = require(path.to.dragon)

local D = Dragon.DataStore("Profiles")

D:Init()
-


# Basic profile structure

-
local Dragon = require(path.to.dragon)

local PlayerService = game:GetService("Players")

local D = Dragon.DataStore("Profiles")

D:Init({ Scope = "V1" }) -- Sets scope


PlayerService.PlayerAdded:Connect(function(Player: Player)
  local Profile = D:Get(Player.UserId):Now()
  print(Profile)
end)
-
