
local Dragon = script:FindFirstAncestor("Dragon")

local DataStoreService = game:GetService("DataStoreService")
local SharedTableRegistry = game:GetService("SharedTableRegistry")

local MemoryStoreService = game:GetService("MemoryStoreService")
local Sessions = MemoryStoreService:GetHashMap("Dragon_Sessions")

local Logs = require(Dragon.Logs)
local Util = require(Dragon.Util)

local DataM = require(Dragon.Methods.DataM)

local D = {}
D.__index = D


function CREATEOBJECT_G(self, LastFunction, Key: string?)

	local GetObject = { LastFunction = LastFunction, Origin = self.Name, Scope = self.Scope, Configuration = self.Configuration, Store = self.Store, Key = Key }
	return GetObject

end


function D:Init(Table: { Scope: string?, Options: DataStoreOptions? }): ()
	
	if not Table then Table = {} end
	
	local Name = self.Name :: string
	if not Name or typeof(Name) ~= "string" then warn(Logs["Prefix"] .. Logs["WARNINGS"]["001"]) Name = "Global" end
	
	local DataStore = DataStoreService:GetDataStore(Name, Table["Scope"], Table["Options"])
	
	self.Store = DataStore
	self.Configuration = { }
	self.Scope = Table["Scope"]
	
end


function D:Template(Table: { [string]: any }, RemovesOutdatedKeys: boolean?)
	
	if typeof(Table) ~= "table" then warn(Logs["Prefix"] .. Logs["WARNINGS"]["003"]) return end
	self.Template = Table
	
	SharedTableRegistry:SetSharedTable(`Template ({self.Name})`, SharedTable.new(Table))
	
	
	if RemovesOutdatedKeys then
		self.Configuration.RemovesOutdatedKeys = true
	end
	
end


function D:Reconcile(Data: { [string]: any }): { [string]: any }
	
	local Config = self.Configuration or { }
	
	return Util.ReconcileTable(DataTable or {}, self.Template or {}, Config["RemovesOutdatedKeys"])
	
end


function D:SetDataStoreGetOptions(Options: DataStoreGetOptions): ()
	
	local Configuration = self.Configuration or {}
	Configuration["GetOptions"] = Options
	
	self.Configuration = Configuration
	
end


function D:SetDataStoreSetOptions(Options: DataStoreSetOptions): ()
	
	local Configuration = self.Configuration or {}
	Configuration["SetOptions"] = Options
	
	self.Configuration = Configuration
	
end


function D:Get(Key: string)
	
	local Configuration = self.Configuration or { }
	
	local DataStore = self.Store :: DataStore
	
	local LastFunction = function()
		return DataStore:GetAsync(Key, Configuration["GetOptions"])
	end
	
	return setmetatable(CREATEOBJECT_G(self, LastFunction, Key), DataM)
	
end


function D:Set(Key: string, Value: any, UserIds: { number? })

	local Configuration = self.Configuration or { }

	local DataStore = self.Store :: DataStore

	local LastFunction = function()
		return DataStore:SetAsync(Key, Value, UserIds, Configuration["SetOptions"])
	end
	
	return setmetatable(CREATEOBJECT_G(self, LastFunction, Key), DataM)

end


function D:Update(Key: string, TransformFunction: (Data: any) -> (any))

	local Configuration = self.Configuration or { }

	local DataStore = self.Store :: DataStore

	local LastFunction = function()
		return DataStore:UpdateAsync(Key, TransformFunction)
	end
	
	return setmetatable(CREATEOBJECT_G(self, LastFunction, Key), DataM)

end


return D
