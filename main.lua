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
                                                                @Version:       v0.1
                                                                @Created on:    4/15/2018 - 9:26PM
]]
local Game = require("modules/game")

function love.load()
    Game.init()
end

function love.update(dt)
    if Game.started == false then return nil end

    Game.bird.time = Game.bird.time - dt
    if Game.bird.time <= 0 then
        Game.bird.time = 1 / Game.bird.fps

        if Game.bird.activeFrame == 3 then Game.bird.activeFrame = 1 end
        Game.bird.activeFrame = Game.bird.activeFrame + 1
    end
end

function love.draw()
    love.graphics.draw(Game.background, 0, -Game.floor:getHeight() / 10)
    love.graphics.draw(Game.floor, 0, love.graphics.getHeight() - Game.floor:getHeight() / 2, 0, 0.5, 0.5)
    love.graphics.draw(Game.sprites, Game.title, love.graphics.getWidth() / 2, love.graphics.getHeight() / 5, 0, 0.5, 0.5, ({Game.title:getViewport()})[3] / 2, ({Game.title:getViewport()})[4] / 2)
    love.graphics.draw(Game.sprites, Game.bird.frames[Game.bird.activeFrame], love.graphics.getWidth() / 2, love.graphics.getHeight() / 3, 0, 0.7, 0.7, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[3] / 2, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[4] / 2)
end

function love.quit()
    print("Game ended!")
end