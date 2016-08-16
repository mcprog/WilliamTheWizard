local background = {}

BACKGROUND_WIDTH = 816

function background.init()
  background.layers = {}
  background.y = 0

  background.layers[0] = {}
  background.layers[0].img = love.graphics.newImage("images/background/parallax-forest-back-trees.png")
  background.layerSetup(background.layers[0])
  background.layers[0].speed = 30

  background.layers[1] = {}
  background.layers[1].img = love.graphics.newImage("images/background/parallax-forest-lights.png")
  background.layerSetup(background.layers[1])
  background.layers[1].speed = 0

  background.layers[2] = {}
  background.layers[2].img = love.graphics.newImage("images/background/parallax-forest-middle-trees.png")
  background.layerSetup(background.layers[2])
  background.layers[2].speed = 60

  background.layers[3] = {}
  background.layers[3].img = background.loadImg("parallax-forest-front-trees")
  background.layerSetup(background.layers[3])
  background.layers[3].speed = 120
end

function background.loadImg (name)
  return love.graphics.newImage("images/background/" .. name .. ".png")
end

function background.layerSetup(layer)
  layer.img:setFilter("nearest", "nearest")
  layer.xA = 0
  layer.xB = BACKGROUND_WIDTH
end

function background.update(dt)
  for i = 0, #background.layers do

    --pop values out for conveinence
    currentA = background.layers[i].xA
    currentB = background.layers[i].xB
    if (currentA <= -816) then
      currentA = 816
    end
    if (currentB <= -816) then
      currentB = 816
    end
    -- gap check
    if (currentA < currentB) then
      currentB = currentA + 816
    elseif (currentA > currentB) then
      currentA = currentB + 816
    end

    currentA = currentA - (background.layers[i].speed * dt)
    currentB = currentB - (background.layers[i].speed * dt)

    --push values back in to store properly
    background.layers[i].xA = currentA
    background.layers[i].xB = currentB
  end

end

function background.draw ()
  for i = 0, #background.layers do
    layer = background.layers[i];
    love.graphics.draw(layer.img, layer.xA, background.y, 0, 3, 3, 0, 0)
    love.graphics.draw(layer.img, layer.xB, background.y, 0, 3, 3, 0, 0)
  end
end

return background
