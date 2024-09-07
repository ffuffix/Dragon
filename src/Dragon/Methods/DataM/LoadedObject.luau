
local Dragon = script:FindFirstAncestor("Dragon")

local SharedTableRegistry = game:GetService("SharedTableRegistry")

local MemoryStoreService = game:GetService("MemoryStoreService")
local Sessions = MemoryStoreService:GetHashMap("Dragon_Sessions")

local HttpService = game:GetService("HttpService")

local Util = require(Dragon.Util)
local Logs = require(Dragon.Logs)


local LoadedObject = {}
LoadedObject.__index = LoadedObject


function LoadedObject:GetContent()
	return self
end


function LoadedObject:Reconcile()
	
	local Info = self.Info
	local Origin = Info.Origin
	
	local Template = SharedTableRegistry:GetSharedTable(`Template ({Origin.Name})`)
	
	local Data = self.Data or {}
	self.Data = Util.ReconcileTable(Data, Template, self.Info.Config["RemovesOutdatedKeys"])
	
	return self
	
end


function LoadedObject:GetData()
	
	return self.Data
	
end


function LoadedObject:Release()
	
	if self.Threads and next(self.Threads) ~= nil then
		for Idx, Thread in self.Threads do
			task.cancel(Thread)
			self.Threads[Idx] = nil
		end
		
		for Idx, Connection in self.Connections or {} do
			Connection:Disconnect()
		end
	else
		warn(Logs["Prefix"] .. Logs["WARNINGS"]["005"])
	end
	
	return self
	
end


function LoadedObject:Attributes(FolderName: string?)
	
	if not self.Player then warn(Logs["Prefix"] .. Logs["WARNINGS"]["006"]) return self end
	if typeof(self.Data) ~= "table" then warn(Logs["Prefix"] .. Logs["WARNINGS"]["007"]) return self end
	
	local Attributes = Instance.new("Folder")
	Attributes.Name = FolderName or "Attributes"
	
	Attributes.Parent = self.Player
	
	local CurrentData = self.Data
	
	
	if not self.Connections then self.Connections = {} end


	for K, V in CurrentData do
		local IsTableValue = if typeof(V) == "table" then true else false
		
		Attributes:SetAttribute(K, if IsTableValue then HttpService:JSONEncode(V) else V)
		
		self.Connections["Attribute_" .. K] = Attributes:GetAttributeChangedSignal(K):Connect(function()
			
			local ChangedValue = Attributes:GetAttribute(K)
			
			self.Data[K] = if IsTableValue then HttpService:JSONDecode(ChangedValue) else ChangedValue
			self.Info.Saved = false
			
		end)
	end
	
	
	return self
	
end


function LoadedObject:CreateSession(T: { Player: Player?, SessionLocked: boolean?, SessionExpiration: number?, SaveRate: number? })
	
	local Store = self.Info.Store :: DataStore
	local Key = self.Info.Key :: string
	
	if Sessions:GetAsync(Key) then
		warn(Logs["Prefix"] .. Logs["WARNINGS"]["004"]:format(Key))
		return self
	end
	
	local Data = self.Data
	
	local Player = T["Player"]
	local SessionLocked = T["SessionLocked"]
	local SessionExpiration = T["SessionExpiration"]
	local SaveRate = T["SaveRate"]
	
	
	if SessionLocked then
		Sessions:SetAsync(Key, true, SessionExpiration or 86400)
	end
	
	self.Info["Saved"] = true
	
	local D_1 = Player ~= nil
	
	if D_1 then
		self.Player = Player
	end
	
	local ID = if Player then Player.UserId else nil
	
	local Thread = task.spawn(function()
		
		while task.wait(SaveRate or 4) do
			if not Util.Matching(Data, self.Data) or not self.Info.Saved then
				self.Info.Saved = false
				
				Data = self.Data
				
				pcall(function()
					
					Store:SetAsync(Key, self.Data, if ID then { ID } else nil)
					self.Info.Saved = true
					
				end)
			end
			
			if D_1 then
				if not Player then break end
			end
			
		end
		
	end)
	
	if not self.Threads then self.Threads = {} end
	self.Threads["Session"] = Thread
	
	return self

end


return LoadedObject
