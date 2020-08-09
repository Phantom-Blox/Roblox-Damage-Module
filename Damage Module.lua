local Settings = require(script.Settings)
local BlockingHumanoidsList = {}
local ArmorHumanoidsList = {}
local DamageModule = {}
DamageModule.Blocked = function(Humanoid)
	if Settings.Block.Enabled then
		local FoundBlockingHumanoid = false
		for i = 1,#BlockingHumanoidsList do local BlockingHumanoid = BlockingHumanoidsList[i]
			if BlockingHumanoid == Humanoid then
				FoundBlockingHumanoid = true
				warn("The humanoid is already blocking!")
				break
			end
		end
		if not FoundBlockingHumanoid then
			table.insert(BlockingHumanoidsList,1,Humanoid)
		end
	else
		warn("Blocking is not enabled! You can enable it in the settings module.")
	end
end

DamageModule.Unblocked = function(Humanoid)
	if Settings.Block.Enabled then
		local FoundBlockingHumanoid = false
		for i = 1, #BlockingHumanoidsList do local BlockingHumanoid = BlockingHumanoidsList[i]
			if BlockingHumanoid == Humanoid then
				FoundBlockingHumanoid = true
				table.remove(BlockingHumanoidsList,i)
				break
			end
		end
		if not FoundBlockingHumanoid then
			warn("The humanoid is not blocking right now!")
		end
	else
		warn("Blocking is not enabled! You can enable it in the settings module.")
	end
end

DamageModule.AddArmor = function(Humanoid,DamageReduce,Percentage)
	if Settings.Armor.Enabled then
		local FoundArmorHumanoid = false
		for ArmorHumanoid, Data in pairs (ArmorHumanoidsList) do
			if ArmorHumanoid == Humanoid then
				FoundArmorHumanoid = true
				warn("This humanoid already got an armor!")
				break
			end
		end
		if not FoundArmorHumanoid then
			local ArmorData = {DamageReduce,Percentage}
			ArmorHumanoidsList[Humanoid] = ArmorData
		end
	else
		warn("Armor is not enabled! You can enable it in the settings module.")
	end
end

DamageModule.RemoveArmor = function(Humanoid)
	if Settings.Armor.Enabled then
		local FoundArmorHumanoid = false
		for ArmorHumanoid, Data in pairs (ArmorHumanoidsList) do
			if ArmorHumanoid == Humanoid then
				FoundArmorHumanoid = true
				ArmorHumanoidsList[Humanoid] = nil
				break
			end
		end
		if not FoundArmorHumanoid then
			warn("The humanoid doesn't have an armor to remove!")
		end
	else
		warn("Armor is not enabled! You can enable it in the settings module.")
	end
end

DamageModule.Damage = function(Humanoid,Damage)
	local DamageIgnoresForcefield = Settings.DamageIgnoresForcefield
	local Block = Settings.Block
	local Armor = Settings.Armor
	local ModifyDamage = Damage
	
	if Block.Enabled then
		for i = 1, #BlockingHumanoidsList do local BlockHumanoid = BlockingHumanoidsList[i]
			if BlockHumanoid == Humanoid then
				local ModifyDamageSave = ModifyDamage
				ModifyDamage = (ModifyDamageSave - Block["Damage Reduce"])
				if ModifyDamage < 0 then
					ModifyDamage = 0
				end
				ModifyDamage = ModifyDamage - (ModifyDamageSave * (Block.Percentage / 100))
				break
			end
		end
	end
	if Armor.Enabled then
		for ArmorHumanoid, Data in pairs (ArmorHumanoidsList) do
			if ArmorHumanoid == Humanoid then
				local ModifyDamageSave = ModifyDamage
				ModifyDamage = (ModifyDamageSave - Data[1])
				if ModifyDamage < 0 then
					ModifyDamage = 0
				end
				ModifyDamage = ModifyDamage - (ModifyDamageSave * (Data[2] / 100))
				break
			end
		end
	end
	
	if DamageIgnoresForcefield.Enabled then
		Humanoid.Health = Humanoid.Health - ModifyDamage
	else
		Humanoid:TakeDamage(ModifyDamage)
	end
end

return DamageModule
