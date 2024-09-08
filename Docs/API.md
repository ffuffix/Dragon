# Dragon API Documentation

## Overview
Dragon is a powerful and flexible data solution for Roblox experiences. This document provides an overview of the API and how to use it effectively.

## Table of Contents
1. Getting Started
2. Endpoints
    - Create Data
    - Read Data
    - Update Data
    - Delete Data
4. Error Handling
5. Examples
6. FAQ

## Getting Started
To get started with Dragon, you have to get the latest version of Dragon which can be found on this github repository.


## Endpoints

### Create

To create data use :Set()
```luau
D:Set("Dragon", true):Now()
```


### Read

To read data use :Get() alongside :GetData() to get the data
```luau
D:Get("Dragon"):Now():GetData()
```


### Update

To update data use :Update()
```luau
D:Update("Dragon", function(Data)
	
	if not Data then Data = {} end
	
		Data["Gold"] = (Data["Gold"] or 0) + 25
	
	return Data
	
end):Now()
```


### Delete

To delete data use :Delete()
```luau
D:Delete("BabyDragon"):Now()
```



## Error Handling

Using the :Catch() we can catch errors and do stuff with them if needed

```luau
D:Get("Dragon"):Now()
	:Catch(function(a0) 
		print("An error occured while getting data")

        a0:Release() --> terminates / releases
	end)
```


## Examples


### Storing data and retrieving them

```luau
local Dragon = require("path.to.dragon")
local D = Dragon.DataStore("Data")

D:Init({ Scope = "V1" })


D:Set("Server", { PrivateServerId = 1111, Realm = "Public" }):Now()

task.wait(4)

local ServerData = D:Get("Server"):Now():GetData() 
print("Server Information:", ServerData)
```


### Automatic Profile Sessions

```luau
local Dragon = require(game:GetService("ServerScriptService"):WaitForChild("Dragon"))

local D = Dragon.DataStore("Profiles")

local PlayerService = game:GetService("Players")


D:Init({ Scope = "V1" })

D:Template({ Gold = 0, Treasure = 0 }, true) -- Second argument indicates if it should remove outdated keys if this is changed.


PlayerService.PlayerAdded:Connect(function(Player: Player)
	
	D:Get(Player.UserId):UntilSuccess()
		:Reconcile()
		:CreateSession({ Player = Player }) -- Makes it save automatically
		:Attributes("Profile")
		
		:Catch(function(a0, Reason: string?)  
			
			print("An error occured while saving data:", Reason)
			
		end)
	
	
	-- Random values but changing them via Attributes
	while Player and task.wait(3) do
		
		Player:FindFirstChild("Profile"):SetAttribute("Gold", math.random(0, 25))
		
	end
	
end)
```