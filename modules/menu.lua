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
local Menu = {}
local Game = require("modules/game")

function Menu.showMainMenu()
    Game.paused = false
    Game.switchSprites('active')
    Game.bird.activeFrame = 1

    love.graphics.draw(Game.sprites.current, Game.title, love.graphics.getWidth() / 2, love.graphics.getHeight() / 5, 0, 0.4, 0.4, ({Game.title:getViewport()})[3] / 2, ({Game.title:getViewport()})[4] / 2)
    love.graphics.draw(Game.sprites.current, Game.buttons.play, love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.buttons.play:getViewport()})[3] / 2, ({Game.buttons.play:getViewport()})[4] / 2)
    love.graphics.draw(Game.sprites.current, Game.buttons.board, 3 * love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.buttons.board:getViewport()})[3] / 2, ({Game.buttons.board:getViewport()})[4] / 2)
end

function Menu.showPauseMenu()
    love.graphics.draw(Game.sprites.active, Game.buttons.pause, love.graphics.getWidth() / 2, 1.8 * love.graphics.getHeight() / 3, 0, 0.5, 0.5, ({Game.buttons.pause:getViewport()})[3] / 2, ({Game.buttons.pause:getViewport()})[4] / 2)
end

return Menu