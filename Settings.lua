local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = {
	["Armor"] = {
		["Enabled"] = true,
	};
	
	["Block"] = {
		["Enabled"] = true,
		["Damage Reduce"] = 100,
		["Percentage"] = 20,
	};
	
	["DamageIgnoresForcefield"] = {
		["Enabled"] = false
	}
	
}

return Settings
