BINDING_HEADER_PRIESTBINDS = "PriestBinds"
BINDING_HEADER_EMPTY = " "
BINDING_HEADER_DISC = " "
BINDING_HEADER_SHADOW = " "
BINDING_HEADER_RACIAL = " "
BINDING_HEADER_CODE = " "

-- DISC BINDS
BINDING_NAME_DISC_DM = "Dispel Magic"
BINDING_NAME_DISC_DS = "Divine Spirit"
BINDING_NAME_DISC_IFI = "Inner Fire"
BINDING_NAME_DISC_IFO = "Inner Focus"
BINDING_NAME_DISC_LEV = "Levitate"
BINDING_NAME_DISC_MB = "Mana Burn"
BINDING_NAME_DISC_PI = "Power Infusion"
BINDING_NAME_DISC_PWF = "Power Word: Fortitude"
BINDING_NAME_DISC_PWS = "Power Word: Shield"
BINDING_NAME_DISC_POF = "Prayer of Fortitude"
BINDING_NAME_DISC_POS = "Prayer of Spirit"
BINDING_NAME_DISC_SU = "Shackle Undead"

-- HOLY BINDS
BINDING_NAME_HOLY_AD = "Abolish Disease"
BINDING_NAME_HOLY_CD = "Cure Disease"
BINDING_NAME_HOLY_FH1 = "Flash Heal(Rank 1)"
BINDING_NAME_HOLY_FH2 = "Flash Heal(Rank 2)"
BINDING_NAME_HOLY_FH3 = "Flash Heal(Rank 3)"
BINDING_NAME_HOLY_FH4 = "Flash Heal(Rank 4)"
BINDING_NAME_HOLY_FH5 = "Flash Heal(Rank 5)"
BINDING_NAME_HOLY_FH6 = "Flash Heal(Rank 6)"
BINDING_NAME_HOLY_FH7 = "Flash Heal(Rank 7)"
BINDING_NAME_HOLY_GH1 = "Greater Heal(Rank 1)"
BINDING_NAME_HOLY_GH2 = "Greater Heal(Rank 2)"
BINDING_NAME_HOLY_GH3 = "Greater Heal(Rank 3)"
BINDING_NAME_HOLY_GH4 = "Greater Heal(Rank 4)"
BINDING_NAME_HOLY_GH5 = "Greater Heal(Rank 5)"
BINDING_NAME_HOLY_H1 = "Heal(Rank 1)"
BINDING_NAME_HOLY_H2 = "Heal(Rank 2)"
BINDING_NAME_HOLY_H3 = "Heal(Rank 3)"
BINDING_NAME_HOLY_H4 = "Heal(Rank 4)"
BINDING_NAME_HOLY_HF = "Holy Fire"
BINDING_NAME_HOLY_LH1 = "Lesser Heal(Rank 1)"
BINDING_NAME_HOLY_LH2 = "Lesser Heal(Rank 2)"
BINDING_NAME_HOLY_LH3 = "Lesser Heal(Rank 3)"
BINDING_NAME_HOLY_PH1 = "Prayer of Healing(Rank 1)"
BINDING_NAME_HOLY_PH2 = "Prayer of Healing(Rank 2)"
BINDING_NAME_HOLY_PH3 = "Prayer of Healing(Rank 3)"
BINDING_NAME_HOLY_PH4 = "Prayer of Healing(Rank 4)"
BINDING_NAME_HOLY_PH5 = "Prayer of Healing(Rank 5)"
BINDING_NAME_HOLY_R = "Renew"
BINDING_NAME_HOLY_REZZ = "Resurrection"
BINDING_NAME_HOLY_SMITE = "Smite"

-- SHADOW BINDS
BINDING_NAME_SHADOW_FADE = "Fade"
BINDING_NAME_SHADOW_MAB = "Mana Burn"
BINDING_NAME_SHADOW_MIB = "Mind Blast"
BINDING_NAME_SHADOW_MC = "Mind Control"
BINDING_NAME_SHADOW_MS = "Mind Soothe"
BINDING_NAME_SHADOW_MV = "Mind Vision"
BINDING_NAME_SHADOW_POSP = "Prayer of Shadow Protection"
BINDING_NAME_SHADOW_PS = "Psychic Scream"
BINDING_NAME_SHADOW_SP = "Shadow Protection"
BINDING_NAME_SHADOW_SWP = "Shadow Word: Pain"
BINDING_NAME_SHADOW_SWP1 = "Shadow Word: Pain(Rank 1)"

-- RACIALS
BINDING_NAME_RACIAL_DP = "Devouring Plague"
BINDING_NAME_RACIAL_TOW = "Touch of Weakness"

BINDING_NAME_CODE_CONSTANT = "Constant Healing"

local function print(msg) if msg then DEFAULT_CHAT_FRAME:AddMessage(msg, 255, 255, 0) end end
local ch = {}

ch.units = {}

ch.onEvent = function ()
	if ( event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_STOP" or event == "SPELLCAST_FAILED" ) then
		ch.casting = false
	elseif event == "RAID_ROSTER_UPDATE" then
		local num = GetNumRaidMembers()
		
		for k,v in pairs(ch.units) do
			ch.units.k = nil
		end
		
		for raidIndex = 1,num do
			local name, _, _, _, class = GetRaidRosterInfo(raidIndex)
		
			ch.units[name] = raidIndex			
		end
	end
end

local function check()
	if UnitHealthMax(ch.target) - UnitHealth(ch.target) < 100 then
		SpellStopCasting();
		print("spell stop casting")
		
		ch.casting = false
	end		
end

ch.onUpdate = function ()
	if not ch.casting then return end
	if GetTime() < ch.timer then return end
	
	print("on update")
	
	-- we're past the check time
	check()
end




ch.f = CreateFrame("frame")
ch.f:RegisterEvent("SPELLCAST_START")
ch.f:RegisterEvent("SPELLCAST_STOP")
ch.f:RegisterEvent("SPELLCAST_FAILED")
ch.f:RegisterEvent("SPELLCAST_INTERRUPTED")
ch.f:RegisterEvent("RAID_ROSTER_UPDATE")
ch.f:SetScript("OnEvent", ch.onEvent)
ch.f:SetScript("OnUpdate", ch.onUpdate)

ch.check = 2
	 
ch.msg = "constant healing"
function pb_ConstantHealing()
	
	if not UnitExists("target") then return end
	
	if not ch.casting then 
		CastSpellByName("Heal(Rank 2)")
		ch.casting = true
		ch.timer = GetTime() + (2.5 - ch.check) * 1
	
		print(GetTime() .. " -> " ..ch.timer)
	
		local raidid = ch.units[UnitName("target")]
		if raidid then 
			ch.target = "raid"..raidid
			print(UnitName("target") .. " has id " .. raidid)
		else 
			ch.target = "target"
			print("tracking target")
		end
	--elseif GetTime() > ch.timer and (UnitHealthMax(ch.target) - UnitHealth(ch.target)) < 100 then
	elseif UnitHealthMax(ch.target) - UnitHealth(ch.target) < 100 then
		SpellStopCasting()
		print("spell stop casting")
		
		ch.casting = false	
	end
end