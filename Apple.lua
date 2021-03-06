Apple = {}

function Apple.new(x, y, world)
  local self = self or {}
  self.img = love.graphics.newImage("images/apple.png")
  self.img:setFilter("nearest", "nearest")
  self.body = love.physics.newBody(world, x, y, "kinematic")
  self.shape = love.physics.newRectangleShape(17, 19)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setUserData("Apple")
  self.fixture:setSensor(true)
  self.body:setLinearVelocity(-100, 0)

  --member functions
  function self.draw()
    local currentX, currentY = self.body:getWorldPoints(self.shape:getPoints())
    love.graphics.draw(self.img, currentX, currentY, 0, 1, 1, 0, 0)
    --love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end

  function self.isDestroyed()
    return self.body:isDestroyed();
  end

  function self.getX()
    return self.body:getX()
  end

  function self.setPosition(newX, newY)
    self.body:setPosition(newX, newY)
  end

  return self
end
