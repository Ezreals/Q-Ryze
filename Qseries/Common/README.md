VPrediction API 
 
Menus explanations:
 
-> Collision
                 -> Buffer: It's the extra width that will be added to the moving minions. Increase it if you are hitting minions. (Default value: 20)
                 -> Normal minions / Jungle Minions / Other minions: you can select the objects you don't want to hit. Take into account that in dominion the towers are                                   considered as jungle minions since they are neutral.
                 -> Minion health prediction: VPrediction will check if the minions will be dead when the skillshot reaches their location.
                 -> Unit pos / Cast Pos / Predicted Pos: The positions you want to check for collisions with minions, I recommend to Enabled at least unit pos and Cast                                   Pos or Predicted Pos.
 
-> Cast Mode: VPrediction will check if the target is trying to dodge or if it is hard to hit him and it won't shot in those situations. With this option you can select how much checks will be done to find those situations. So the faster you set it between the 3 options the faster the skillshots will be casted but with less accuracy.
 
Methods:
    Position, HitChance    = VPrediction:GetPredictedPos(hero, delay, speed, from, collision)
        Position: Returns where the enemy is going to be after X seconds delay
        Hitchance: Returns a number indicating the hit chance. (read below for more details)
        
    CastPosition,  HitChance,  Position = VPrediction:GetCircularCastPosition(hero, delay, width, range, speed, from, collision)
        CastPosition: Returns the position where a circular skillshot should be casted
        Position: Returns where the enemy is going to be after X seconds delay
        Hitchance: Returns a number indicating the hit chance. (read below for more details)
       
    CastPosition,  HitChance,  Position = VPrediction:GetLineCastPosition(hero, delay, width, range, speed, from, collision)
        CastPosition: Returns the position where a lineal skillshot should be casted
        Position: Returns where the enemy is going to be after X seconds delay
        Hitchance: Returns a number indicating the hit chance. (read below for more details)
    
    AOECastPosition, MainTargetHitChance, nTargets = VPrediction:GetCircularAOECastPosition(unit, delay, radius, range, speed, from)
        AOECastPosition: Returns the position where the circular skillshot should be casted to hit as many enemies as posible.
        nTargets: Returns the number of targets the skillshot will hit.
        MainTargetHitChance: Returns a number indicating the hit chance for the main target.
 
AOECastPosition, MainTargetHitChance, nTargets = VPrediction:GetLineAOECastPosition(unit, delay, radius, range, speed, from)
        AOECastPosition: Returns the position where the line skillshot should be casted to hit as many enemies as posible.
        nTargets: Returns the number of targets the skillshot will hit.
        MainTargetHitChance: Returns a number indicating the hit chance for the main target.
 
    -delay and speed in seconds and units per second
    -speed and from are optional
    -collision is a optional boolean true/false.
 
Hitchance:
    The hitchance is a number indicating how likely the hero will be hit:
        - -1: Collision detected.
        - 0: No waypoints found for the target, returning target current position
        - 1: Low hitchance to hit the target
        - 2: High hitchance to hit the target
        - 3: Target too slowed or/and too close , (~100% hit chance)
        - 4: Target inmmobile, (~100% hit chace)
        - 5: Target dashing or blinking. (~100% hit chance)
 
Extra methods:
IsImmobile, position = VPrediction:IsImmobile(unit, delay, radius, speed, from)
     Returns true if the target will be hit when the skillshot arrives.
TargetDashing, CanHit, Position = VPrediction:IsDashing(unit, delay, radius, speed, from)
    Returns true if the target is dashing, CanHit will be true if the skillshot casted at Position will hit.
Health = VPrediction:GetPredictedHealth(unit, time)
    Returns the health the unit will have after time seconds. Only supports minions atm.
