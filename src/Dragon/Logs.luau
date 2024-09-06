return table.freeze({
	
	Prefix = "[Dragon] :: ",
	
	["WARNINGS"] = {
		
		["001"] = "Name is nil, using 'Global' instead.\nDid you forget to call :Init()?\nYou will most likely encounter an error after this.",
		["002"] = "Reconcile will not work if Template hasn't been set. Did you forget to call :Template( { [string]: value } )?",
		["003"] = "Template requires a table to be set.",
		["004"] = "Current key [%s] is currently in a locked session and can't have another session attached to it.",
		["005"] = "There are no threads, the current object does not have a session.",
		["006"] = "Can't call :Attributes() when :CreateSession() hasn't been called or :CreateSession() lacks Player argument.",
		["007"] = "Data must be a table in order to use :Attributes()",
		
	},
	
})
