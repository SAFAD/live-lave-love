require "class" 
 
player = class:new()

player.value = 'X'

function player:setvalue(v)
    self.value = v
end

function player:draw(dt)

end