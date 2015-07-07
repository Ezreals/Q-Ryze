--[[

update log
Q Ryze First realese 1.001 5/1
Q information plus 1.002 5/1
Q Ryze SAC MMA Support 1.003 5/1
Combo Changed 1.0031 5/1
error edit 1.0032 5/1
menu Many Edited 1.0033 5/7
Small Fixed 1.0034 5/7
Fixed HPred 1.13 Support 1.0035 5/9
Small Prediction Fixed 1.0036 5/19
Packet Cast Added 1.004 6/4
Some Bug Fixed 1.0041 6/5
1.0042 Key Changed 6/6
1.0043 W E BUG Fixed 6/6
1.0045 6/7 Target Bug Fixed --< NotYet.. but Test..
Harass Q Fixed 1.0046 6/9
1.005 Many Updated.. 6/25 5.12 Patch Support
1.006 Lastest Update Thank you For Using This Scripts
Support Stopped Will Be Reborn
special Thanks To HTTF!
Author qkwlqk
Next Update Gapcloser and R SmartLogic Add
]]
----------------------------
if (myHero.charName ~= "Ryze") then 
  return 
end
MyHero = GetMyHero()
local ignite = nil
local version = "1.006"
local Author = "qkwlqk"
local Date = "7/8"
local Thxto = "HTTF"
local FCharge = false
local PStacks = 0


function updater()
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
  PrintChat("<font color=\"#D1B2FF\">Q Ryze successfully Loaded!")
  PrintChat("<font color=\"#D1B2FF\">Q Ryze Last Supported Version successfully Loaded! Thanks for Use My Scripts!")
  lib()
  Orbload()
  Menu()
  ts= TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100)
  qts= TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100)
  Update()
  FindSummoners()
  HPred = HPrediction()
  SpellData()
  updater()
end



function Menu()
  Menu = scriptConfig("QRyze", "Q Ryze")
    Menu:addSubMenu("Draw Settings", "Draw")
          Menu.Draw:addParam("draw", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Menu:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('C'))
    Menu:addParam("fullcombo", "SBTW", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu:addParam("ignite", "Ignite", SCRIPT_PARAM_ONOFF, true)
    Menu:addParam("Author","Author",SCRIPT_PARAM_INFO,Author)
    Menu:addParam("Version","Version",SCRIPT_PARAM_INFO,version)
    Menu:addParam("LastUpdate","LastUpdate",SCRIPT_PARAM_INFO,Date)
    Menu:addParam("Thanks","SpecialThanksTo",SCRIPT_PARAM_INFO,Thxto)
    Menu:addSubMenu("HitChance", "HitChance")
          Menu.HitChance:addParam("CHitChance","Combo Hitchance",SCRIPT_PARAM_SLICE, 1.2, 1, 3, 2)
          Menu.HitChance:addParam("HHitChance","Harass Hitchance",SCRIPT_PARAM_SLICE, 1.8, 1, 3, 2)
    if VIP_USER then
    Menu:addSubMenu("Misc", "Misc")
          Menu.Misc:addParam("UsePacket", "Use Packet", SCRIPT_PARAM_ONOFF, false)
					end
    Menu:addSubMenu("Harass Settings", "Harass")
          Menu.Harass:addParam("Q", "Use Q ", SCRIPT_PARAM_ONOFF, true)
          Menu.Harass:addParam("W", "Use W ", SCRIPT_PARAM_ONOFF, true)
          Menu.Harass:addParam("E", "Use E ", SCRIPT_PARAM_ONOFF, true)
    Menu:addSubMenu("Combo Settings", "Combo")
          Menu.Combo:addParam("Q", "Use Q ", SCRIPT_PARAM_ONOFF, true)
          Menu.Combo:addParam("W", "Use W ", SCRIPT_PARAM_ONOFF, true)
          Menu.Combo:addParam("E", "Use E ", SCRIPT_PARAM_ONOFF, true)
          Menu.Combo:addParam("R", "Use R ", SCRIPT_PARAM_ONOFF, true)
end


function OnTick()
  qts:update()
  ts:update()
  Harass()
  Pass()
  FullCombo()
  Ignite()
end


function Harass()
local HarassQ = Menu.Harass.Q
local HarassW = Menu.Harass.W
local HarassE = Menu.Harass.E

  if (qts.target ~= nil) and not (qts.target.dead) and (qts.target.visible) then
    if (Menu.harass) then
        if (myHero:CanUseSpell(_W) == READY and HarassW) then
        if (MyHero:GetDistance(ts.target) <= 585) then
        if Menu.Misc.UsePacket then
        Packet("S_CAST", {spellId = _W, targetNetworkId = qts.target.networkID}):send()
    else
          CastSpell(_W, qts.target)
        end
        end
end
if (myHero:CanUseSpell(_Q) == READY and HarassQ) then
if (Menu.harass) then
  local Q2Pos, Q2HitChance = HPred:GetPredict(HP_Q2, qts.target, myHero)
  if Q2HitChance >= Menu.HitChance.HHitChance then
    if Menu.Misc.UsePacket then
      Packet("S_CAST", {spellId = _Q, toX = Q2Pos.x, toY = Q2Pos.z, fromX = Q2Pos.x, fromY = Q2Pos.z}):send()
    else
      CastSpell(_Q, Q2Pos.x, Q2Pos.z)
    end
  end
end
end
        if (myHero:CanUseSpell(_E) == READY and HarassE) then
        if (Menu.harass) then
        if Menu.Misc.UsePacket then
        if (MyHero:GetDistance(ts.target) <= 585) then
        Packet("S_CAST", {spellId = _E, targetNetworkId = qts.target.networkID}):send()
    else
          CastSpell(_E, qts.target)
        end
        end
     end
    end
   end
  end
 end



function FullCombo()

  local ComboQ = Menu.Combo.Q
  local ComboW = Menu.Combo.W
  local ComboE = Menu.Combo.E
  local ComboR = Menu.Combo.R
  
  if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
  
    if (Menu.fullcombo) then
    
      if (myHero:CanUseSpell(_R) == READY and ComboR) then
      
        if Menu.Misc.UsePacket then
        if (MyHero:GetDistance(ts.target) <= 585) then
          Packet("S_CAST", {spellId = _R}):send()
        else
          CastSpell(_R)
        end
        end
        end
      end
      
    end
    
    if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
    if (myHero:CanUseSpell(_W) == READY and ComboW) then
    
      if (Menu.fullcombo) then
      
        if Menu.Misc.UsePacket then
        if (MyHero:GetDistance(ts.target) <= 585) then
          Packet("S_CAST", {spellId = _W, targetNetworkId = ts.target.networkID}):send()
        else
          CastSpell(_W, ts.target)
        end
        end
      end
      end
    end
    
    if (myHero:CanUseSpell(_Q) == READY and ComboQ) then
      if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
      if (Menu.fullcombo) then
      
        local QPos, QHitChance = HPred:GetPredict(HP_Q, ts.target, myHero)
        
        if QHitChance >= Menu.HitChance.CHitChance then
        
          if Menu.Misc.UsePacket then
            Packet("S_CAST", {spellId = _Q, toX = QPos.x, toY = QPos.z, fromX = QPos.x, fromY = QPos.z}):send()
          else
            CastSpell(_Q, QPos.x, QPos.z)
          end
        end
        end
        
      end
      
    end
          if (ts.target ~= nil) and not (ts.target.dead) and (ts.target.visible) then
    if (myHero:CanUseSpell(_E) == READY and ComboE) then
    
      if (Menu.fullcombo) then
      
        if Menu.Misc.UsePacket then
        if (MyHero:GetDistance(ts.target) <= 585) then
          Packet("S_CAST", {spellId = _E, targetNetworkId = ts.target.networkID}):send()
        else
          CastSpell(_E, ts.target)
        end
        
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
      if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and (Menu.ignite) then
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
  if (Menu.Draw.draw) then
    DrawCircle(myHero.x, myHero.y, myHero.z, 950, RGB(255, 0, 0))
  end
end

function Orbwalk()

  if _G.AutoCarry then
  
    if _G.Reborn_Initialised then
      RebornLoaded = true
      PrintChat("<font color=\"#D1B2FF\">Found Sida Auto Carry : Reborn.")
    else
      RevampedLoaded = true
      PrintChat("<font color=\"#D1B2FF\">Found Sida Auto Carry : Revamped.")
    end
    
  elseif _G.Reborn_Loaded then
    DelayAction(Orbwalk, 1)
  elseif _G.MMA_Loaded then
    MMALoaded = true
    PrintChat("<font color=\"#D1B2FF\">Found Marksman's Mighty Assistant.")
  elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
  
    require 'SxOrbWalk'
    
    SxOrbMenu = scriptConfig("SxOrbwalk Settings", "SxOrb")
    
    SxOrb = SxOrbWalk()
    SxOrb:LoadToMenu(SxOrbMenu)
    
    SxOrbLoaded = true
    PrintChat("<font color=\"#D1B2FF\">Found SxOrbwalk.")
  elseif FileExist(LIB_PATH .. "SOW.lua") then
  
    require 'SOW'
    require 'VPrediction'
    
    VP = VPrediction()
    SOWVP = SOW(VP)
    
    Menu:addSubMenu("Orbwalk Settings (SOW)", "Orbwalk")
      Menu.Orbwalk:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
      Menu.Orbwalk:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
      SOWVP:LoadToMenu(Menu.Orbwalk)
      
    SOWLoaded = true
    PrintChat("<font color=\"#D1B2FF\">Found SOW.")
  else
    PrintChat("<font color=\"#D1B2FF\">Orbwalk not founded.")
  end
  
end

function Orbload()
RebornLoaded, RevampedLoaded, MMALoaded, SxOrbLoaded, SOWLoaded = false, false, false, false, false
DelayAction(Orbwalk, 1)
end

function Clear()

end

function JungleClear()
end

function KillSteal()
end


function Update()
  if RebornLoaded then
    Target = _G.AutoCarry.Crosshair:GetTarget()
  elseif RevampedLoaded then
    Target = _G.AutoCarry.Orbwalker.target
  elseif MMALoaded then
    Target = _G.MMA_Target
  elseif SxOrbLoaded then
    Target = SxOrb:GetTarget()
  elseif SOWLoaded then
    Target = SOWVP:GetTarget()
  if Target and Target.type == myHero.type and ValidTarget(Target, TrueRange(Target)) then
    QTarget = Target
    WTarget = Target
    ETarget = Target
  else
    QTS:update()
    WTS:update()
    ETS:update()
    QTarget = QTS.target
    WTarget = WTS.target
    ETarget = ETS.target
  end
end
end

function SpellData()
HP_Q = HPSkillshot({collisionM = false, collisionH = false, type = "DelayLine", delay = .25, range = 925, width = 110, speed = 1700})
HP_Q2 = HPSkillshot({collisionM = true, collisionH = false, type = "DelayLine", delay = .25, range = 925, width = 110, speed = 1700})
end

function OnUpdateBuff(unit, buff, stacks)
  if buff.name =="ryzepassivestack" then
  Pstacks = stacks
  end
  if buff.name == "ryzepassivecharged" then
  FCharge = true
  end
end
function TargetHaveBuff(buffName, target) --function to check our buffs
    assert(type(buffName) == "string" or type(buffName) == "table", "TargetHaveBuff: wrong argument types (<string> or <table of string> expected for buffName)")
    local target = target or player
    for i = 1, target.buffCount do
        local tBuff = target:getBuff(i)
        if BuffIsValid(tBuff) then
            if type(buffName) == "string" then
                if tBuff.name:lower() == buffName:lower() then return true end
            else
                for _, sBuff in ipairs(buffName) do
                    if tBuff.name:lower() == sBuff:lower() then return true end
                end
            end
        end
    end
    return false
end

function Pass()
  if not TargetHaveBuff("ryzepassivestack", myHero) or TargetHaveBuff("ryzepassivecharged", myHero) then
    PStacks = 0
  end
  if not TargetHaveBuff("ryzepassivecharged", myHero) then
    FCharge = false
  end
end
