local Util = {}


function Util.DeepCopy(Table)

	local Copy = {}
	
	for Key, Value in Table do
		if type(Value) == "table" then
			Copy[Key] = Util.DeepCopy(Value)
		else
			Copy[Key] = Value
		end
	end
	
	return Copy
end


function Util.ReconcileTable(Target: { [string]: any }, Template: { [string]: any }, RemovesOutdatedKeys: boolean?)
	
	if not Target then Target = {} end 
	
	for Key, Value in Template do
		if type(Key) ~= "string" then continue end
		
		if Target[Key] == nil then
			if type(Value) == "table" then
				Target[Key] = Util.DeepCopy(Value)
			else
				Target[Key] = Value
			end
		elseif type(Target[Key]) == "table" and type(Value) == "table" then
			Util.ReconcileTable(Target[Key], Value)
		end
	end
	
	if RemovesOutdatedKeys then
		for Key, Value in Target do
			if type(Key) ~= "string" then continue end

			if not Template[Key] then
				Target[Key] = nil
			end
		end
	end
	
	return Target
	
end


function Util.Matching(T1: { [string]: any}, T2: {[string]: any })
	
	for K, V in T1 do
		if not T2[K] then return false end
		
		if typeof(V) == "table" and typeof(T2[K]) == "table" then
			local Result = Util.Matching(V, T2[K])
			
			if Result == false then return false end
			
			continue
		end
		
		if T2[K] ~= V then return false end
	end
	
	for K, V in T2 do 
		if not T1[K] then return false end
		
		if typeof(V) == "table" and typeof(T1[K]) == "table" then
			local Result = Util.Matching(V, T1[K])
			
			if Result == false then return false end

			continue
		end

		if T1[K] ~= V then return false end
	end
	
	return true
	
end


return Util
