
local Dragon = script:FindFirstAncestor("Dragon")

local Meta = Dragon.Meta

local Data = require(Meta.Data)

return table.freeze({
	
	["Data"] = function(Name: string) return setmetatable({ Name = Name }, Data) end,
	
})
