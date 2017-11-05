Animation = {
  name = '',
  sprite_sheet_path = nil,
  sprite_sheet = nil,
  quads = {},
  duration = 3,
  current_time = 0,
  play_animation = false
};

function Animation:new(obj)
  obj = obj or {};
  setmetatable(obj, self);
  self.__index = self;
  return obj;
end

function Animation:play()
  self.play_animation = true;
end

function Animation:pause()
  self.play_animation = false;
end

function Animation:load(width, height)
  local image = love.graphics.newImage(self.sprite_sheet_path);

  self.sprite_sheet = image;
  self.quads = {};
  for y = 0, image:getHeight() - height, height do
      for x = 0, image:getWidth() - width, width do
          table.insert(self.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
      end
  end

  self.duration = duration or 3
  self.current_time = 0
end

function Animation:update(dt)
  if self.play_animation then
    self.current_time = self.current_time + dt
      if self.current_time >= self.duration then
          self.current_time = self.current_time - self.duration
      end
  end
end

function Animation:draw(x,y, orientation)
  if self.play_animation then
    -- ( length / 4 ) * orientation [0,1,2,3]
    orientation = orientation or 1;
    local spriteNum = math.floor(self.current_time / self.duration * #self.quads) + 1

    -- get orientation of character
    local number_of_animations_per_row = (table.getn(self.quads) / 4);

    position_in_row = (spriteNum % number_of_animations_per_row);
    if position_in_row == 0 then
      spriteNum = number_of_animations_per_row * (orientation + 1);
    else
      spriteNum = position_in_row + (orientation * number_of_animations_per_row)
    end

    --print ('oriented spriteNum', spriteNum)

    love.graphics.draw(self.sprite_sheet, self.quads[spriteNum], x, y, 0, 1)
  end
end

return Animation;
