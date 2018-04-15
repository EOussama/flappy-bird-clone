local Game = {
    started = false,
    background = nil,
    floor = nil,
    sprites = nil,
    title = nil,
    bird = {
        fps = 15,
        activeFrame = 1,
        frames = {}
    }
}
Game.__index = Game

-- Functions
function Game.init()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Game.started = false
    Game.background = love.graphics.newImage("assets/drawables/background.png")
    Game.floor = love.graphics.newImage("assets/drawables/floor.png")
    Game.sprites = love.graphics.newImage("assets/drawables/sprites_sheet.png")

    Game.title = love.graphics.newQuad(1060, 10, 455, 132, Game.sprites:getDimensions())
    Game.bird.frames[1] = love.graphics.newQuad(674, 0, 86, 61, Game.sprites:getDimensions())
    Game.bird.frames[2] = love.graphics.newQuad(674, 61, 86, 61, Game.sprites:getDimensions())
    Game.bird.frames[3] = love.graphics.newQuad(674, 122, 86, 61, Game.sprites:getDimensions())
end

function Game.start()
    print("Game started")
end

function Game.paused()
    print("Game paused")
end

function Game.loss()
    print("Game over")
end

return Game