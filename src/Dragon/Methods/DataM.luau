
local Dragon = script:FindFirstAncestor("Dragon")
local LoadedObject = require(Dragon.Methods.Objects.LoadedObject)

local M = {}
M.__index = M


function CREATEOBJECT(self, Success: boolean, Response: any)
	
	local Config = self.Configuration
	local Origin = { Name = self.Origin, Scope = self.Scope }
	local Object = { Info = { Success = Success, Origin = Origin, Config = Config, Store = self.Store, Key = self.Key }, Data = Response }
	
	return Object
	
end


local Data = {}


function M:Now()
	
	local LastFunction = self.LastFunction :: () -> (any)
	local Success, Response = pcall(LastFunction)
	
	return setmetatable(CREATEOBJECT(self, Success, Response), LoadedObject)
	
end


function M:UntilSuccess(DelayPerTry: number?, Tries: number?)
	
	local LastFunction = self.LastFunction :: () -> (any)
	local Response = nil
	
	local Tries = Tries or 20
	
	repeat
		
		local Success, Response = pcall(LastFunction)
		
		if Success then
			
			return setmetatable(CREATEOBJECT(self, true, Response), LoadedObject)
			
		else
			task.wait(DelayPerTry or 3)
		end
		
		Tries = Tries - 1
		
	until Tries <= 0
	
	return setmetatable(CREATEOBJECT(self, false, Response), LoadedObject)
	
end


return M