FruitSpawner = {}

function FruitSpawner.new (Fruit, maxFruit, minHeight)
  local self = self or {}
  self.Fruit = Fruit
  self.fruits = {}
  self.maxFruit = maxFruit
  self.minHeight = minHeight

  --member functions
  function self.update()
    if (#self.fruit > self.maxFruit) then
      return
    end

  end

  return self
end
