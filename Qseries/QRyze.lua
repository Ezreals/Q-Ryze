
require "SxOrbWalk"
require "HPrediction"
if (myHero.charName ~= "Ryze") then 
  return 
end
local ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 900)
local ignite = nil
local Author = qkwlqk
local Version = "0.2"
local AutoUpdate = true
local Host = "raw.github.com"

local ScriptFilePath = SCRIPT_PARH..GetCurrentEnv().FILE_NAME
local UpdateURL = "https://"..Host..ScriptPath

local VersionPath = "/qkwlqk/BoL/tree/master/Qseries/Version/Qryze.version".."?rand="..math.random(1,10000)
local VersionData = tonumber(GetWebResult(Host, VersionPath))

if AutoUpdate then

  if VersionData then
  
    ServerVersion = type(VersionData) == "number" and VersionData or nil
    
    if ServerVersion then
    
      if tonumber(Version) < ServerVersion then
        ScriptMsg("New version available: v"..VersionData)
        ScriptMsg("Updating, please don't press F9.")
        DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
      else
        ScriptMsg("You've got the latest version: v"..Version)
      end
      
    end
    
  else
    ScriptMsg("Error downloading version info.")
  end
  
else
  ScriptMsg("AutoUpdate: false")
end



function OnLoad()
  PrintChat("<font color=\"#0000FF\">Q Ryze successfully Loaded!")
  Menu()
  FindSummoners()
  HPred = HPrediction()
  Spell_Q.collisionM['Ryze'] = true
  Spell_Q.collisionH['Ryze'] = true --or false
  Spell_Q.delay['Ryze'] = 0.25
  Spell_Q.range['Ryze'] = 900
  Spell_Q.speed['Ryze'] = 1400
  Spell_Q.type['Ryze'] = "DelayLine"
  Spell_Q.width['Ryze'] = 50
end

function Menu()
  Config = scriptConfig("QRyze", "Q Ryze")
  
    Config:addParam("draw", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    Config:addParam("fullcombo", "SBTW", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
    Config:addParam("ignite", "Ignite", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("Author","Author",SCRIPT_PARAM_INFO,"qkwlqk")
    Config:addParam("Version","Version",SCRIPT_PARAM_INFO,"0.1")
    Config:addParam("CHitChance","Combo Hitchance",SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
    Config:addParam("HHitChance","Harass Hitchance",SCRIPT_PARAM_SLICE, 1.8, 1, 3, 2)
    Config:addSubMenu("orbwalk", "SxOrbWalk")
      SxOrb:LoadToMenu(Config.SxOrbWalk)
      Config:addTS(ts)
end

function OnTick() 
  ts:update()
  Harass()
  FullCombo()
  Ignite()
  Zhonya()
end

function Harass()
  if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
    if (Config.harass) then
      if (myHero:GetDistance(ts.target) <= 900) then
              if (myHero:CanUseSpell(_Q) == READY) then
local Pos, HitChance = HPred:GetPredict("Q", ts.target, myHero)
if HitChance >= Config.HHitChance then
  CastSpell(_Q, Pos.x, Pos.z)
end
        if (myHero:CanUseSpell(_W) == READY) then
          CastSpell(_W, ts.target)
        end
        if (myHero:CanUseSpell(_E) == READY) then
          CastSpell(_E, ts.target)
        end
      end
    end
  end
end
end
function FullCombo()
  if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
    if (Config.fullcombo) then
      if (myHero:GetDistance(ts.target) <= 900) then
        if (myHero:CanUseSpell(_R) == READY) then
          CastSpell(_R)
        end
        if (myHero:CanUseSpell(_Q) == READY) then
local Pos, HitChance = HPred:GetPredict("Q", ts.target, myHero)
if HitChance >= Config.HHitChance then
  CastSpell(_Q, Pos.x, Pos.z)
end
        if (myHero:CanUseSpell(_W) == READY) then
          CastSpell(_W, ts.target)
        end
        end
        if (myHero:CanUseSpell(_E) == READY) then
          CastSpell(_E, ts.target)
        end
      end
    end
  end
end

function FindSummoners()
  if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
    ignite = SUMMONER_1
  elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
    ignite = SUMMONER_2
  else
    ignite = nil
  end
end

function Ignite()
  if ignite ~= nil then
    local iDmg = (50 + (20 * myHero.level))
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and (Config.ignite) then
        if (myHero:CanUseSpell(ignite) == READY) then
          if enemy.health < iDmg then
            CastSpell(ignite, enemy)
          end
        end 
      end 
    end  
  end
end

function OnDraw()
  if (myHero.dead) then return end
  if (Config.draw) then
    DrawCircle(myHero.x, myHero.y, myHero.z, 900, RGB(255, 0, 0))
  end
end
