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
    constants = {
        getstarted_time = 3,
        pixels_per_meter = 64,
        gravity = 9.81,
    },
    conf = {
        started = false,
        getstarted = {
            time = getstarted_time,
            state = false
        },
        lost = false,
        paused = false,
        played = false
    },
    physics = {
        physicsWorld = nil,
        ceilling = {
            world = physicsWorld,
            body = nil,
            shape = nil,
            fixture = nil
        }
    },
    assets = {
        drawables = {
            background = {
                current = nil,
                active = nil,
                paused = nil
            },
            floor = {
                current = nil,
                active = nil,
                paused = nil,
                posX = 0.0,
                physics = {
                    world = physicsWorld,
                    body = nil,
                    shape = nil,
                    fixture = nil
                }
            },
            sprites =  {
                current = nil,
                active = nil,
                paused = nil
            }
        },
        sounds = {
            pass = nil,
            lost = nil
        }
    },
    quads = {
        interface = {
            title = nil,
            caption = nil,
            gameOver = nil,
            scoreBoard = nil,
            numbers = {},
            buttons = {
                play = nil,
                board = nil,
                tap = nil
            }
        },
        bird = {
            posX = love.graphics.getWidth() / 2,
            posY = love.graphics.getHeight() / 2.6,
            fps = 10,
            time = 1 / 10,
            swing = false,
            activeFrame = 1,
            frames = {},
            physics = {
                world = physicsWorld,
                body = nil,
                shape = nil,
                fixture = nil
            },
        },
        pipes = {
            ceil = nil,
            floor = nil,
            pps = nil,
            pos = {
                X,
                Y
            }
        }
    },
}
Game.__index = Game

-- Functions
function Game.init()
    -- Settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    Game.conf.getstarted.time = Game.constants.getstarted_time

    -- Resources
    Game.conf.started = false
    Game.assets.drawables.background.active = love.graphics.newImage("assets/drawables/background.png")
    Game.assets.drawables.background.paused = love.graphics.newImage("assets/drawables/background_paused.png")
    Game.assets.drawables.floor.active = love.graphics.newImage("assets/drawables/floor.png")
    Game.assets.drawables.floor.paused = love.graphics.newImage("assets/drawables/floor_paused.png")
    Game.assets.drawables.sprites.active = love.graphics.newImage("assets/drawables/sprites_sheet.png")
    Game.assets.drawables.sprites.paused = love.graphics.newImage("assets/drawables/sprites_sheet_paused.png")
    Game.assets.sounds.pass = love.audio.newSource("assets/sound/pass.ogg", "static")
    Game.assets.sounds.lost = love.audio.newSource("assets/sound/loss.ogg", "static")

    -- Instances
    Game.assets.drawables.background.current = Game.assets.drawables.background.active
    Game.assets.drawables.floor.current = Game.assets.drawables.floor.active
    Game.assets.drawables.sprites.current = Game.assets.drawables.sprites.active

    -- Physics
    love.physics.setMeter(Game.constants.pixels_per_meter)
    Game.physics.physicsWorld = love.physics.newWorld(0, Game.constants.gravity * Game.constants.pixels_per_meter, true)

    Game.assets.drawables.floor.physics.world = Game.physics.physicsWorld
    Game.assets.drawables.floor.physics.body = love.physics.newBody(Game.assets.drawables.floor.physics.world, love.graphics:getWidth() / 2, love.graphics:getHeight(), 'static')
    Game.assets.drawables.floor.physics.shape = love.physics.newRectangleShape(Game.assets.drawables.floor.current:getWidth(), 210)
    Game.assets.drawables.floor.physics.fixture = love.physics.newFixture(Game.assets.drawables.floor.physics.body, Game.assets.drawables.floor.physics.shape, 1)
    
    Game.physics.ceilling.world = Game.physics.physicsWorld
    Game.physics.ceilling.body = love.physics.newBody(Game.physics.ceilling.world, love.graphics:getWidth() / 2, 0, 'static')
    Game.physics.ceilling.shape = love.physics.newRectangleShape(love.graphics:getWidth(), 100)
    Game.physics.ceilling.fixture = love.physics.newFixture(Game.physics.ceilling.body, Game.physics.ceilling.shape, 1)

    Game.quads.bird.physics.world = Game.physics.physicsWorld
    Game.quads.bird.physics.body = love.physics.newBody(Game.quads.bird.physics.world, Game.quads.bird.posX, Game.quads.bird.posY, 'dynamic')
    Game.quads.bird.physics.shape = love.physics.newCircleShape(50)
    Game.quads.bird.physics.fixture = love.physics.newFixture(Game.quads.bird.physics.body, Game.quads.bird.physics.shape, 1)
    Game.quads.bird.physics.fixture:setRestitution(0.3)

    -- Quad setting
    Game.quads.interface.title = love.graphics.newQuad(1060, 10, 455, 132, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.caption = love.graphics.newQuad(519, 311, 472, 140, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.gameOver = love.graphics.newQuad(10, 310, 490, 122, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.scoreBoard = love.graphics.newQuad(10, 0, 579, 301, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.buttons.play = love.graphics.newQuad(459, 460, 272, 161, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.buttons.board = love.graphics.newQuad(1562, 0, 272, 161, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.buttons.tap = love.graphics.newQuad(760, 0, 285, 250, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.bird.time = 1 / Game.quads.bird.fps
    Game.quads.bird.frames[1] = love.graphics.newQuad(674, 0, 86, 61, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.bird.frames[2] = love.graphics.newQuad(674, 61, 86, 61, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.bird.frames[3] = love.graphics.newQuad(674, 122, 86, 61, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.pipes.ceil = love.graphics.newQuad(10, 478, 130, 801, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.pipes.floor = love.graphics.newQuad(160, 188, 130, 801, Game.assets.drawables.sprites.current:getDimensions())

    if math.random() == 0 then Game.quads.pipes.pps = Game.quads.pipes.floor else Game.quads.pipes.pps = Game.quads.pipes.ceil end
    Game.quads.pipes.pos.Y = 500
    Game.quads.pipes.pos.X = love.graphics:getWidth() + ({Game.quads.pipes.pps:getViewport()})[3] / 2

    Game.quads.interface.numbers[0] = love.graphics.newQuad(1019, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[1] = love.graphics.newQuad(1080, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[2] = love.graphics.newQuad(1140, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[3] = love.graphics.newQuad(1210, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[4] = love.graphics.newQuad(1280, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[5] = love.graphics.newQuad(1350, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[6] = love.graphics.newQuad(1420, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[7] = love.graphics.newQuad(1490, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[8] = love.graphics.newQuad(1560, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
    Game.quads.interface.numbers[9] = love.graphics.newQuad(1630, 300, 60, 91, Game.assets.drawables.sprites.current:getDimensions())
end

function Game.switchSprites(current)
    if current == 'active' then
        Game.assets.drawables.background.current = Game.assets.drawables.background.active
        Game.assets.drawables.floor.current = Game.assets.drawables.floor.active
        Game.assets.drawables.sprites.current = Game.assets.drawables.sprites.active
    elseif current == 'paused' then
        Game.assets.drawables.background.current = Game.assets.drawables.background.paused
        Game.assets.drawables.floor.current = Game.assets.drawables.floor.paused
        Game.assets.drawables.sprites.current = Game.assets.drawables.sprites.paused
    end
end

function Game.birdFly()
    if Game.conf.paused == true then
        Game.conf.paused = false
    else
        Game.quads.bird.physics.body:applyLinearImpulse(0, -600)
        Game.quads.bird.swing = true
    end
end

function Game.getStarted(dt)

    Game.conf.getstarted.time = Game.conf.getstarted.time - dt

    if Game.conf.getstarted.time <= 0 then
        Game.conf.getstarted.time = Game.constants.getstarted_time
        
        Game.conf.getstarted.state = false
        Game.conf.started = true
        
        Game.quads.bird.physics.body:applyLinearImpulse(-1, 0)
    end
end

function Game.draw()
    Game.quads.bird.posX = Game.quads.bird.physics.body:getX()
    Game.quads.bird.posY = Game.quads.bird.physics.body:getY()

    love.graphics.draw(Game.assets.drawables.background.current, 0, -Game.assets.drawables.floor.current:getHeight() / 10)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.bird.frames[Game.quads.bird.activeFrame], Game.quads.bird.posX, Game.quads.bird.posY, 0, 0.6, 0.6, ({Game.quads.bird.frames[Game.quads.bird.activeFrame]:getViewport()})[3] / 2, ({Game.quads.bird.frames[Game.quads.bird.activeFrame]:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.pipes.pps, Game.quads.pipes.pos.X, Game.quads.pipes.pos.Y, 0, 0.5, 0.5, ({Game.quads.pipes.pps:getViewport()})[3]/2, ({Game.quads.pipes.pps:getViewport()})[4]/2)
    love.graphics.draw(Game.assets.drawables.floor.current, Game.assets.drawables.floor.posX, love.graphics.getHeight() - Game.assets.drawables.floor.current:getHeight() / 2, 0, 0.5, 0.5)
end

return Game