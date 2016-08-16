

platform = {}
player = {}
crate1 = {}
background = {}
crateSpawner = {}
local deleteQueue = {}
require "Crate"
local crate2 = nil
local crate1 = nil
local crate3 = nil

require "Apple"
local apple1 = nil
local apples = {}

local bg = require "background"

require "FruitSpawner"
local fruitSpawner = nil

g_Width = love.graphics.getWidth()
g_Height = love.graphics.getHeight()

crateImg = nil

bgImg = nil

local alive = true
local diedImg = nil

local appleImg = nil
local appleCount = 0

function love.load()
  love.physics.setMeter(64) -- 1 meter is 64px
  world = love.physics.newWorld(0, 9.81 * 64, true) -- boolean is sleep for inactive bodies
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  -- platform loading
  platform.width = g_Width
  platform.height = 16
  platform.x = 0
  platform.y = g_Height
  platform.body = love.physics.newBody(world, platform.x + platform.width / 2, platform.y + platform.height / 2)
  platform.shape = love.physics.newRectangleShape(platform.width * 2, platform.height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape) -- attaches to body
  platform.fixture:setUserData("Ground")

  -- player loading
  player.x = g_Width / 2
  player.y = g_Height * .5
  player.bodyWidth = 48
  player.bodyHeight = 64
  player.img = love.graphics.newImage("images/player_0.png")
  player.img:setFilter("nearest", "nearest")
  player.img1 = love.graphics.newImage("images/player_1.png")
  player.img1:setFilter("nearest", "nearest")
  player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
  player.shape = love.physics.newRectangleShape(player.bodyWidth, player.bodyHeight)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1) -- last arg is density
  player.fixture:setUserData("Player")
  player.body:setFixedRotation(true)
  player.maxVX = 200
  player.grounded = false
  player.jumping = false

  --crate1 = Crate.new(0, g_Height + 24, world)
  --crate2 = Crate.new(400, g_Height + 24, world)
  --crate3 = Crate.new(g_Width * 1.5, g_Height + 24, world)
  crateSpawner.crates = {}
  crateSpawner.limit = 10
  crateSpawner.spawn = function()
    if (#crateSpawner.crates < crateSpawner.limit) then
      local randX = math.random(0, g_Width)
      table.insert(crateSpawner.crates, Crate.new(g_Width + randX, g_Height + 24, world))
    end
  end
  crateSpawner.update = function()
    for i = 1, #crateSpawner.crates do
      if (crateSpawner.crates[i].getX() < -24) then
        crateSpawner.crates[i].setX(math.random(0, g_Width) + g_Width)
      end
    end
  end

  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  crateSpawner.spawn()
  --print(#crateSpawner.crates)

  bg.init()

  diedImg = love.graphics.newImage("images/youDied.png")
  diedImg:setFilter("nearest", "nearest")

  apple1 = Apple.new(100, 400, world);
  apples[1] = apple1;

  fruitSpawner = FruitSpawner.new(Apple, 10, 350, world)
end

function love.update(dt)
  if not alive then
    return
  end
  world:update(dt)
  if not world:isLocked() then
    for i = 1, #deleteQueue do
      deleteQueue[i]:destroy()
    end
    deleteQueue = {}
  end



  local vX, vY = player.body:getLinearVelocity()

  if love.keyboard.isDown('a')  then
      player.body:setLinearVelocity(-200, vY)
  elseif love.keyboard.isDown('d') then
      player.body:setLinearVelocity(30, vY)
  else
    player.body:setLinearVelocity(0, vY)
  end

  -- jump key binding
  if love.keyboard.isDown('space') then
      if player.grounded then
        player.grounded = false;
        player.body:applyLinearImpulse(0, -250)
      elseif player.jumping then
        --TODO add jumping
      end
  end

  if love.keyboard.isDown('lshift') then
    player.attacking = true
  else
    player.attacking = false
  end
  bg.update(dt)
  crateSpawner.update()
  fruitSpawner.update()
  if (player.body:getX() < 0) then
    alive = false
  end
end

function love.touchpressed(id, x, y, pressure)
  if player.grounded then
    player.grounded = false;
    player.body:applyLinearImpulse(0, -350)
  end
end

function love.draw()

  love.graphics.setColor(255, 255, 255)

  bg.draw()

  --apple1.draw()
  fruitSpawner.draw()

  local x1, y1 = player.body:getWorldPoints(player.shape:getPoints())

  love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
  local playerImg = nil
  if (player.attacking) then
    playerImg = player.img1
  else
    playerImg = player.img
  end
  love.graphics.draw(playerImg, x1 - 32 + player.bodyWidth / 2, y1, 0, 4, 4, 0, 0)
  --love.graphics.polygon("line", player.body:getWorldPoints(player.shape:getPoints()))

  --crate1.draw()
  --crate2.draw()
  --crate3.draw()
  for i = 1, #crateSpawner.crates do
    crateSpawner.crates[i].draw();
  end

  if not alive then
    --love.graphics.setDefaultFilter("nearest", "nearest", 0)
    local x, y = getCenteredCoords(diedImg, .5, .25, 4)
    love.graphics.draw(diedImg, x, y, 0, 4, 4, 0, 0)
  end
end

function beginContact(a, b, coll)
  local addedData = a:getUserData() .. b:getUserData()
  if (addedData == "GroundPlayer") or
      (addedData == "PlayerGround") or
      (addedData == "CratePlayer") or
      (addedData == "PlayerCrate") then
    player.grounded = true;
  end
  if (a:getUserData() == "Apple") then
    collectApple(a)
  elseif (b:getUserData() == "Apple") then
    collectApple(b)
  end

end

function collectApple(fixture)
  appleCount = appleCount + 1;
  print("apples: " .. appleCount)
  fixture:setUserData("Delete")
  table.insert(deleteQueue, fixture:getBody())
end

function endContact(a, b, coll)
  local addedData = a:getUserData() .. b:getUserData()
  if (addedData == "GroundPlayer") or
      (addedData == "PlayerGround") or
      (addedData == "CratePlayer") or
      (addedData == "PlayerCrate") then
    player.jumping = true;
  end

end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalImp, tangentImp)
end

function signum(num)
  if num < 0 then
    return -1
  end
  return 1
end

function getCenteredCoords (img, xRatio, yRatio, scale)
  local x = g_Width * xRatio - img:getWidth() * scale / 2
  local y = g_Height * yRatio - img:getHeight() * scale / 2
  return x, y
end
