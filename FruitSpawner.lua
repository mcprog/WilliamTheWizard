FruitSpawner = {}

function FruitSpawner.new(Fruit, maxFruit, minHeight, world)
  local self = self or {}
  self.Fruit = Fruit
  self.fruits = {}
  self.maxFruit = maxFruit
  self.minHeight = minHeight
  self.world = world

  --member functions
  function self.update()
    for i = 1, #self.fruits do
      if self.fruits[i].isDestroyed() then
        table.remove(self.fruits, i)
        break
      elseif (self.fruits[i].getX() < -24) then
        self.fruits[i].setPosition(math.random(0, g_Width) + g_Width, math.random(0, self.minHeight))
      end
    end

    if (#self.fruits > self.maxFruit) then
      return
    end
    local newFruit = self.Fruit.new(math.random(0, g_Width) + g_Width, math.random(0, self.minHeight), self.world)
    table.insert(self.fruits, newFruit)

  end

  function self.draw()
    for i = 1, #self.fruits do
      if self.fruits[i].isDestroyed() then

      else
        self.fruits[i].draw()
      end
    end
  end

  return self
end
