Crate = {}

function Crate.new(leftX, bottomY, world)
  local self = self or {}
  self.img = love.graphics.newImage("images/crate.png")
  self.img:setFilter("nearest", "nearest")
  self.body = love.physics.newBody(world, leftX + 24, bottomY - 48, "kinematic")
  self.shape = love.physics.newRectangleShape(48, 48)
  self.fixture = love.physics.newFixture(self.body, self.shape, 2)
  self.fixture:setUserData("Crate")
  self.body:setFixedRotation(true)
  self.body:setLinearVelocity(-120, 0)

  --member functions
  function self.draw()
    local currentX, currentY = self.body:getWorldPoints(self.shape:getPoints())
    love.graphics.draw(self.img, currentX, currentY, 0, 2, 2, 0, 0)
  end

  function self.update(dt)
  end

  function self.setX(newX)
    self.body:setX(newX)
  end

  function self.getX()
    return self.body:getX()
  end

  return self
end
