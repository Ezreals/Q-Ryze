local latestVersion=nil
local updateCheck = false
local VERSION = "1.6"
local ts = nil

function getDownloadVersion(response)
        latestVersion = response
end

function getVersion()
        GetAsyncWebResult("dl.dropboxusercontent.com","/s/1iiacl9ttbhj897/GSversion.txt",getDownloadVersion)
end 

function update()
    if updateCheck == false then
        local PATH = BOL_PATH.."Scripts\\GetSpell.lua"
        local URL = "http://dl.dropboxusercontent.com/s/adwcu9s3n0gqlbl/GetSpell.lua"
        if latestVersion~=nil and latestVersion ~= VERSION then
            updateCheck = true
            PrintChat("UPDATING GetSpell - "..SCRIPT_PATH:gsub("/", "\\").."GetSpell.lua")
            DownloadFile(URL, PATH,function ()
                PrintChat("UPDATED - reload please (F9 twice)")
            end)            
        elseif latestVersion == VERSION then
            updateCheck = true
            PrintChat("Your Version of GetSpell is up to date")        
        end
    end
end
AddTickCallback(update)

function OnLoad()
	getVersion()
	objectname1 = "name"
	objectname2 = "name"
	objectname3 = "name"
	objectstart1 = 0
	objectstart2 = 0
	objectstart3 = 0
	objectend1 = 0
	objectend2 = 0
	objectend3 = 0
	lastobj = 3
	castfrom1 = 0
	castfrom2 = 0
	castfrom3 = 0
	range1 = 0
	range2 = 0
	range3 = 0
	projspeed1 = 0
	projspeed2= 0
	projspeed3 = 0
	Qwind = 0
	Wwind = 0
	Ewind = 0
	Rwind = 0
	AAwind = "0"
	Qwidth = 0
	Wwidth = 0
	Ewidth = 0
	Rwidth = 0
	menu()
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1300, DAMAGE_PHYSICAL)
	ts.name = myHero.charName
    SCmen:addTS(ts)
end

function menu()
	SCmen = scriptConfig("GetSpell", "Get Spell")
	SCmen:addParam("GS","GetSpell V1.0", SCRIPT_PARAM_INFO, "")
	
	SCmen:addSubMenu("Objects", "obj")
	SCmen:addSubMenu("Range", "rng")
	SCmen:addSubMenu("Projectile Speed", "prjSpd")
	SCmen:addSubMenu("Orb Walking", "oWalk")
	
	SCmen.obj:addParam("objShow","Show Object Names", SCRIPT_PARAM_ONOFF, true)
	SCmen.obj:addParam("objTar","Filter Out _tar objects", SCRIPT_PARAM_ONOFF, true)
	
	SCmen.rng:addParam("rngShow", "Show Projectile Range", SCRIPT_PARAM_ONOFF, true)
	
	SCmen.prjSpd:addParam("prjShow", "Show Projectile Speed", SCRIPT_PARAM_ONOFF, true)
	
	SCmen:addParam("showWidth", "Show Projectile Width", SCRIPT_PARAM_ONOFF, true)
	
	SCmen.oWalk:addParam("OshowWind", "Display Windup Times", SCRIPT_PARAM_ONOFF, true)
	SCmen:addParam("PrintMyBuffs", "Print Buffs on Me", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	SCmen:addParam("PrintHisBuffs", "Print Buffs on Target", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	SCmen:addParam("PrintAllBuffs", "Print All Buffs of All Targets", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	
	SCmen:permaShow("PrintMyBuffs")
    SCmen:permaShow("PrintHisBuffs")
    SCmen:permaShow("PrintAllBuffs")
end

function OnTick()
	ts:update()
	Target = ts.target
	if SCmen.PrintMyBuffs then
		for i = 1, myHero.buffCount, 1 do
			if myHero:getBuff(i).name ~= nil then
				PrintChat("champ : "..myHero.charName.." buff "..i.." : "..myHero:getBuff(i).name)
			end
		end
	end
	if SCmen.PrintHisBuffs and Target ~= nil then
		for i = 1, Target.buffCount, 1 do
			if Target:getBuff(i).name ~= nil then
				PrintChat("champ : "..Target.charName.." buff "..i.." : "..Target:getBuff(i).name)
			end
		end
	end
	if SCmen.PrintAllBuffs then
		for i = 1, heroManager.iCount, 1 do
			local champ = heroManager:getHero(i)
			if champ ~= nil then
				for o = 1, champ.buffCount, 1 do
					if champ:getBuff(o).name ~= nil then
						PrintChat("champ : "..champ.charName.." buff "..o.." : "..champ:getBuff(o).name)
					end
				end
			end
		end
	end
	if SCmen.showWidth then
		Qwidth = myHero:GetSpellData(_Q).lineWidth
		Wwidth = myHero:GetSpellData(_W).lineWidth
		Ewidth = myHero:GetSpellData(_E).lineWidth
		Rwidth = myHero:GetSpellData(_R).lineWidth
	end
end

function OnProcessSpell(object, spell)
	if spell.name == myQ.name then
		Qwind = spell.windUpTime
	elseif spell.name == myW.name then
		Wwind = spell.windUpTime
	elseif spell.name == myE.name then
		Ewind = spell.windUpTime
	elseif spell.name == myR.name then
		Rwind = spell.windUpTime
	elseif GetDistance(object) < 50 then
		AAwind = spell.windUpTime
	end
end

function OnDraw()
	leftOffSet = 10
	topOffset = 10
	
	myQ = myHero:GetSpellData(_Q)
	myW = myHero:GetSpellData(_W)
	myE = myHero:GetSpellData(_E)
	myR = myHero:GetSpellData(_R)
	
	DrawText("Hero = " .. myHero.charName .. " spellNames = " .. myQ.name .. " " .. myW.name  .. " " .. myE.name  .. " " .. myR.name , 16, 10, topOffset, 0xFF00FF00)
	if SCmen.obj.objShow then
		DrawText("Object1 name = " .. objectname1, 16, 10, 100, 0xFF00FF00)
		DrawText("Object2 name = " .. objectname2, 16, 10, 115, 0xFF00FF00)
		DrawText("Object3 name = " .. objectname3, 16, 10, 130, 0xFF00FF00)
	end
	if SCmen.rng.rngShow then
		DrawText("Range1 = " .. range1, 16, 10, 150, 0xFF00FF00)
		DrawText("Range2 = " .. range2, 16, 10, 165, 0xFF00FF00)
		DrawText("Range3 = " .. range3, 16, 10, 180, 0xFF00FF00)
	end
	if SCmen.prjSpd.prjShow then
		DrawText("Proj Speed 1 = " .. projspeed1, 16, 10, 200, 0xFF00FF00)
		DrawText("Proj Speed 2 = " .. projspeed2, 16, 10, 215, 0xFF00FF00)
		DrawText("Proj Speed 3 = " .. projspeed3, 16, 10, 230, 0xFF00FF00)
	end
	if SCmen.oWalk.OshowWind then
		DrawText("Q Windup = " .. Qwind, 16, 10, 250, 0xFF00FF00)
		DrawText("W Windup = " .. Wwind, 16, 10, 265, 0xFF00FF00)
		DrawText("E Windup = " .. Ewind, 16, 10, 280, 0xFF00FF00)
		DrawText("R Windup = " .. Rwind, 16, 10, 295, 0xFF00FF00)
		DrawText("AA Windup = " .. AAwind, 16, 10, 310, 0xFF00FF00)
	end
	if SCmen.showWidth then
		DrawText("Q Width = " .. Qwidth, 16, 10, 330, 0xFF00FF00)
		DrawText("W Width = " .. Wwidth, 16, 10, 345, 0xFF00FF00)
		DrawText("E Width = " .. Ewidth, 16, 10, 360, 0xFF00FF00)
		DrawText("R Width = " .. Rwidth, 16, 10, 375, 0xFF00FF00)
	end
end

function OnCreateObj(object)
	if SCmen.obj.objTar then
		if object.name ~= "DrawFX" and object.name ~= "missile" and string.find(object.name, "GoldAquisition") == nil and string.find(object.name, "idle") == nil
			and string.find(object.name, "Idle") == nil and string.find(object.name, "Mfx") == nil and string.find(object.name, "globalhit") == nil
			and string.find(object.name, "OrderTurret") == nil and string.find(object.name, "ChaosTurret") == nil and string.find(object.name, "bloodslash") == nil
			and object.name ~= "SpikeBullet.troy"  and string.find(object.name, "Golem") == nil  and object.name ~= "TristannaBasicAttack_mis.troy" 
			and object.name ~= "LaserSight_beam.troy"  and string.find(object.name, "minion") == nil  and string.find(object.name, "Audio") == nil
			and object.name ~= "FeelNoPain_eff.troy" and string.find(object.name, "BloodSlash") == nil and string.find(object.name, "Minion") == nil and object.name ~= "empty.troy"
			and string.find(object.name, "BasicAttack") == nil and string.find(object.name, "basicAttack") == nil and string.find(object.name, "monsterCamp") == nil 
			and string.find(object.name, "Chaos_Nexus") == nil and string.find(object.name, "Order_Nexus") == nil and string.find(object.name, "_tar") == nil 
			and string.find(object.name, "LevelUp") == nil and string.find(object.name, "Chaos_Turret") == nil and string.find(object.name, "ElixirSight") == nil
			and string.find(object.name, "Yikes") == nil and string.find(object.name, "yikes") == nil and string.find(object.name, "Global_Slow") == nil
			and string.find(object.name, "Respawn") == nil and string.find(object.name, "DestroyedExplosion") == nil and string.find(object.name, "Inhibit_Crystal") == nil
			and string.find(object.name, "SpawnBeacon") == nil and object.name ~= "dragon_wing.troy" then
			if lastobj == 3 then
				if object.name ~= objectname3 then
					objectname1 = object.name
					castfrom1 = myHero
					objectstart1 = 0
					objectstart1 = GetTickCount()
					lastobj = 1
				end
			end
			if lastobj == 2 then
				if object.name ~= objectname2 then
					objectname3 = object.name
					castfrom3 = myHero
					objectstart3 = GetTickCount()
					lastobj = 3
				end
			end
			if lastobj == 1 then
				if object.name ~= objectname1 then
					objectname2 = object.name
					castfrom2 = myHero
					objectstart2 = GetTickCount()
					lastobj = 2
				end
			end
		end
	elseif object.name ~= "DrawFX" and object.name ~= "missile" and string.find(object.name, "GoldAquisition") == nil and string.find(object.name, "idle") == nil
			and string.find(object.name, "Idle") == nil and string.find(object.name, "Mfx") == nil and string.find(object.name, "globalhit") == nil
			and string.find(object.name, "OrderTurret") == nil and string.find(object.name, "ChaosTurret") == nil and string.find(object.name, "bloodslash") == nil
			and object.name ~= "SpikeBullet.troy"  and string.find(object.name, "Golem") == nil  and object.name ~= "TristannaBasicAttack_mis.troy" 
			and object.name ~= "LaserSight_beam.troy"  and string.find(object.name, "minion") == nil  and string.find(object.name, "Audio") == nil
			and object.name ~= "FeelNoPain_eff.troy" and string.find(object.name, "BloodSlash") == nil and string.find(object.name, "Minion") == nil and object.name ~= "empty.troy"
			and string.find(object.name, "BasicAttack") == nil and string.find(object.name, "basicAttack") == nil and string.find(object.name, "monsterCamp") == nil 
			and string.find(object.name, "Chaos_Nexus") == nil and string.find(object.name, "Order_Nexus") == nil and string.find(object.name, "LevelUp") == nil and string.find(object.name, "Chaos_Turret") == nil and string.find(object.name, "ElixirSight") == nil
			and string.find(object.name, "Yikes") == nil and string.find(object.name, "yikes") == nil and string.find(object.name, "Global_Slow") == nil
			and string.find(object.name, "Respawn") == nil and string.find(object.name, "DestroyedExplosion") == nil and string.find(object.name, "Inhibit_Crystal") == nil
			and string.find(object.name, "SpawnBeacon") == nil then
			if lastobj == 3 then
				if object.name ~= objectname3 then
					objectname1 = object.name
					castfrom1 = myHero
					objectstart1 = 0
					objectstart1 = GetTickCount()
					lastobj = 1
				end
			end
			if lastobj == 2 then
				if object.name ~= objectname2 then
					objectname3 = object.name
					castfrom3 = myHero
					objectstart3 = GetTickCount()
					lastobj = 3
				end
			end
			if lastobj == 1 then
				if object.name ~= objectname1 then
					objectname2 = object.name
					castfrom2 = myHero
					objectstart2 = GetTickCount()
					lastobj = 2
				end
			end
	end
end

function OnDeleteObj(object)
	if object.name == objectname3 then
		range3 = GetDistance(object, castfrom3)
		projspeed3 = 0
		projspeed3 = range3 / (GetTickCount() - objectstart3) * 1000
	end
	if object.name == objectname2 then
		range2 = GetDistance(object, castfrom2)
		projspeed2 = 0
		projspeed2 = range2 / (GetTickCount() - objectstart2) * 1000
	end
	if object.name == objectname1 then
		range1 = GetDistance(object, castfrom1)
		projspeed2 = 0
		projspeed1 = range1 / (GetTickCount() - objectstart1) * 1000
	end
end
