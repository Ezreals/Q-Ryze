----------------------------
require "SxOrbWalk"
require "HPrediction"
if (myHero.charName ~= "Ryze") then 
  return 
end
local ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 900)
local ignite = nil


function updater()
local version = "1.001"
local author = "qkwlqk"
local SCRIPT_NAME = "Q Ryze"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/qkwlqk/BoL/master/Qseries/Q%20Ryze.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Q Ryze:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/qkwlqk/BoL/master/Qseries/Version/Q%20ryze.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        AutoupdaterMsg("New version available "..ServerVersion)
        AutoupdaterMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
      else
        AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
      end
    end
  else
    AutoupdaterMsg("Error downloading version info")
  end
end
function lib()
local REQUIRED_LIBS = {
  ["SxOrbWalk"] = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
  ["HPrediction"] = "https://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua"
}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
  DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
  if DOWNLOAD_COUNT == 0 then
    DOWNLOADING_LIBS = false
    print("<b><font color=\"#6699FF\">Required libraries downloaded successfully, please reload (double F9).</font>")
  end
end

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
  if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
    require(DOWNLOAD_LIB_NAME)
  else
    DOWNLOADING_LIBS = true
    DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
    DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
  end
end
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
  updater()
	lib()
end

function Menu()
  Config = scriptConfig("QRyze", "Q Ryze")
  
    Config:addParam("draw", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    Config:addParam("fullcombo", "SBTW", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
    Config:addParam("ignite", "Ignite", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("Author","Author",SCRIPT_PARAM_INFO,"qkwlqk")
    Config:addParam("Version","Version",SCRIPT_PARAM_INFO,"1.001")
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
