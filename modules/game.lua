--[[
                                                       
                                    ______ _                           ____  _         _        _                  
                                    |  ____| |                         |  _ \(_)       | |      | |                 
                                    | |__  | | __ _ _ __  _ __  _   _  | |_) |_ _ __ __| |   ___| | ___  _ __   ___ 
                                    |  __| | |/ _` | '_ \| '_ \| | | | |  _ <| | '__/ _` |  / __| |/ _ \| '_ \ / _ \
                                    | |    | | (_| | |_) | |_) | |_| | | |_) | | | | (_| | | (__| | (_) | | | |  __/
                                    |_|    |_|\__,_| .__/| .__/ \__, | |____/|_|_|  \__,_|  \___|_|\___/|_| |_|\___|
                                                    | |   | |     __/ |                                              
                                                    |_|   |_|    |___/                                               



                                                        @Author:        Eoussama
                                                        @Version:       v0.2.0
                                                        @Created on:    4/15/2018 - 9:26PM
]]
local Game = {
    started = false,
    getstarted = {
        time = 3,
        state = false
    },
    lost = false,
    paused = false,
    physicsWorld = love.physics.newWorld(0, 9.81*64, true),
    title = nil,
    caption = nil,
    gameOver = nil,
    scoreBoard = nil,
    background = {
        current = nil,
        active = nil,
        paused = nil
    },
    floor = {
        current = nil,
        active = nil,
        paused = nil,
        floorX = 0.0,
        physics = {
            world = nil,
            body = nil,
            shape = nil,
            fixture = nil
        }
    },
    ceilling = {
        physics = {
            world = nil,
            body = nil,
            shape = nil,
            fixture = nil
        }
    },
    sprites = {
        current = nil,
        active = nil,
        paused = nil
    },
    pipes = {
        ceil = nil,
        floor = nil
    }
    bird = {
        posX = love.graphics.getWidth() / 3,
        posY = love.graphics.getHeight() / 2.6,
        fps = 10,
        time = 1 / 10,
        swing = false,
        activeFrame = 1,
        frames = {},
        physics = {
            world = nil,
            body = nil,
            shape = nil,
            fixture = nil
        }
    },
    buttons = {
        play = nil,
        board = nil,
        tap = nil
    },
    numbers = {},
    sounds = {
        played = false,
        pass = nil,
        lost = nil
    }
}
Game.__index = Game

-- Functions
function Game.init()
    -- Settings
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Resources
    Game.started = false
    Game.background.active = love.graphics.newImage("assets/drawables/background.png")
    Game.background.paused = love.graphics.newImage("assets/drawables/background_paused.png")
    Game.floor.active = love.graphics.newImage("assets/drawables/floor.png")
    Game.floor.paused = love.graphics.newImage("assets/drawables/floor_paused.png")
    Game.sprites.active = love.graphics.newImage("assets/drawables/sprites_sheet.png")
    Game.sprites.paused = love.graphics.newImage("assets/drawables/sprites_sheet_paused.png")
    Game.sounds.pass = love.audio.newSource("assets/sound/pass.ogg", "static")
    Game.sounds.lost = love.audio.newSource("assets/sound/loss.ogg", "static")

    -- Instances
    Game.background.current = Game.background.active
    Game.floor.current = Game.floor.active
    Game.sprites.current = Game.sprites.active

    -- Physics
    Game.floor.physics.world = Game.physicsWorld
    Game.floor.physics.body = love.physics.newBody(Game.floor.physics.world, love.graphics:getWidth() / 2, love.graphics:getHeight(), 'static')
    Game.floor.physics.shape = love.physics.newRectangleShape(Game.floor.current:getWidth(), 210)
    Game.floor.physics.fixture = love.physics.newFixture(Game.floor.physics.body, Game.floor.physics.shape, 1)

    Game.ceilling.physics.world = Game.physicsWorld
    Game.ceilling.physics.body = love.physics.newBody(Game.ceilling.physics.world, love.graphics:getWidth() / 2, 0, 'static')
    Game.ceilling.physics.shape = love.physics.newRectangleShape(love.graphics:getWidth(), 50)
    Game.ceilling.physics.fixture = love.physics.newFixture(Game.ceilling.physics.body, Game.ceilling.physics.shape, 1)

    Game.bird.physics.world = Game.physicsWorld
    Game.bird.physics.body = love.physics.newBody(Game.bird.physics.world, Game.bird.posX, Game.bird.posY, 'dynamic')
    Game.bird.physics.shape = love.physics.newCircleShape(50)
    Game.bird.physics.fixture = love.physics.newFixture(Game.bird.physics.body, Game.bird.physics.shape, 1)
    Game.bird.physics.fixture:setRestitution(0.3)

    -- Quad setting
    Game.title = love.graphics.newQuad(1060, 10, 455, 132, Game.sprites.current:getDimensions())
    Game.caption = love.graphics.newQuad(519, 311, 472, 140, Game.sprites.current:getDimensions())
    Game.gameOver = love.graphics.newQuad(10, 310, 490, 122, Game.sprites.current:getDimensions())
    Game.scoreBoard = love.graphics.newQuad(10, 0, 579, 301, Game.sprites.current:getDimensions())
    Game.bird.time = 1 / Game.bird.fps
    Game.bird.frames[1] = love.graphics.newQuad(674, 0, 86, 61, Game.sprites.current:getDimensions())
    Game.bird.frames[2] = love.graphics.newQuad(674, 61, 86, 61, Game.sprites.current:getDimensions())
    Game.bird.frames[3] = love.graphics.newQuad(674, 122, 86, 61, Game.sprites.current:getDimensions())
    Game.buttons.play = love.graphics.newQuad(459, 460, 272, 161, Game.sprites.current:getDimensions())
    Game.buttons.board = love.graphics.newQuad(1562, 0, 272, 161, Game.sprites.current:getDimensions())
    Game.buttons.tap = love.graphics.newQuad(760, 0, 285, 250, Game.sprites.current:getDimensions())
    Game.pipes.ceil = love.graphics.newQuad(10, 478, 130, 801, Game.sprites.current:getDimensions())
    Game.pipes.floor = love.graphics.newQuad(160, 188, 130, 801, Game.sprites.current:getDimensions())

    Game.numbers[0] = love.graphics.newQuad(1019, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[1] = love.graphics.newQuad(1080, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[2] = love.graphics.newQuad(1140, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[3] = love.graphics.newQuad(1210, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[4] = love.graphics.newQuad(1280, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[5] = love.graphics.newQuad(1305, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[6] = love.graphics.newQuad(1420, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[7] = love.graphics.newQuad(1490, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[8] = love.graphics.newQuad(1560, 300, 60, 91, Game.sprites.current:getDimensions())
    Game.numbers[9] = love.graphics.newQuad(1630, 300, 60, 91, Game.sprites.current:getDimensions())
end

function Game.switchSprites(current)
    if current == 'active' then
        Game.background.current = Game.background.active
        Game.floor.current = Game.floor.active
        Game.sprites.current = Game.sprites.active
    elseif current == 'paused' then
        Game.background.current = Game.background.paused
        Game.floor.current = Game.floor.paused
        Game.sprites.current = Game.sprites.paused
    end
end

function Game.birdFly()
    if Game.paused == true then
        Game.paused = false
    else
        Game.bird.physics.body = love.physics.newBody(Game.bird.physics.world, Game.bird.posX, Game.bird.posY, 'dynamic')
        Game.bird.physics.body:applyLinearImpulse(0, -200)
        Game.bird.swing = true
    end
end

function Game.getStarted(dt)
    Game.getstarted.time = Game.getstarted.time - dt

    if Game.getstarted.time <= 0 then
        Game.getstarted.time = 3
        Game.getstarted.state = false
        Game.started = true

        Game.bird.physics.body:applyLinearImpulse(-1, 0)
    end
end

function Game.draw()
    Game.bird.posX = Game.bird.physics.body:getX()
    Game.bird.posY = Game.bird.physics.body:getY()

    love.graphics.draw(Game.background.current, 0, -Game.floor.current:getHeight() / 10)
    love.graphics.draw(Game.floor.current, Game.floor.floorX, love.graphics.getHeight() - Game.floor.current:getHeight() / 2, 0, 0.5, 0.5)
    love.graphics.draw(Game.sprites.current, Game.bird.frames[Game.bird.activeFrame], Game.bird.posX, Game.bird.posY, 0, 0.6, 0.6, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[3] / 2, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[4] / 2)
end

return Game