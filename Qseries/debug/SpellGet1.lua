-- this script is SpellGetData



function OnCreateObj(object)
if object.spellOwner ~=
myHero then
  return
 end
 if object.name == "LineMissile"
then
  StartPos = Vector(object.x,object.y,object.z)
  StartTime = os.clock()
 end
end





function OnDeleteObj(object)
if object.spellOwner ~=
myHero then
  return
 end
 if object.name == "LineMissile"
then
  EndPos = Vector(object.x,object.y,object.z)
  EndTime = os.clock()
 end
end
