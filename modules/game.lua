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
                                                        @Version:       v0.1.0
                                                        @Created on:    4/15/2018 - 9:26PM
]]
local Game = {
    started = false,
    paused = false,
    background = {
        current = nil,
        active = nil,
        paused = nil
    },
    floor = {
        current = nil,
        active = nil,
        paused = nil   
    },
    sprites = {
        current = nil,
        active = nil,
        paused = nil   
    },
    title = nil,
    bird = {
        fps = 15,
        time = nil,
        activeFrame = 1,
        frames = {}
    },
    buttons = {
        play = nil,
        board = nil,
        pause = nil
    }
}
Game.__index = Game

-- Functions
function Game.init()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Game.started = false
    Game.background.active = love.graphics.newImage("assets/drawables/background.png")
    Game.background.paused = love.graphics.newImage("assets/drawables/background_paused.png")
    Game.floor.active = love.graphics.newImage("assets/drawables/floor.png")
    Game.floor.paused = love.graphics.newImage("assets/drawables/floor_paused.png")
    Game.sprites.active = love.graphics.newImage("assets/drawables/sprites_sheet.png")
    Game.sprites.paused = love.graphics.newImage("assets/drawables/sprites_sheet_paused.png")

    Game.background.current = Game.background.active
    Game.floor.current = Game.floor.active
    Game.sprites.current = Game.sprites.active
    Game.title = love.graphics.newQuad(1060, 10, 455, 132, Game.sprites.current:getDimensions())
    Game.bird.time = 1 / Game.bird.fps
    Game.bird.frames[1] = love.graphics.newQuad(674, 0, 86, 61, Game.sprites.current:getDimensions())
    Game.bird.frames[2] = love.graphics.newQuad(674, 61, 86, 61, Game.sprites.current:getDimensions())
    Game.bird.frames[3] = love.graphics.newQuad(674, 122, 86, 61, Game.sprites.current:getDimensions())
    Game.buttons.play = love.graphics.newQuad(459, 460, 272, 161, Game.sprites.current:getDimensions())
    Game.buttons.board = love.graphics.newQuad(1562, 0, 272, 161, Game.sprites.current:getDimensions())
    Game.buttons.pause = love.graphics.newQuad(760, 0, 285, 250, Game.sprites.current:getDimensions())
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
    if Game.paused == true then Game.paused = false end
end

return Game