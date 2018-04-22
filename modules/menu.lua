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
local Menu = {}
local Game = require("modules.game")

function Menu.showMainMenu()
    Game.conf.paused = false
    Game.conf.lost = false
    Game.conf.played = false
    Game.conf.getstarted.state = false
    Game.conf.getstarted.time = Game.constants.getstarted_time
    Game.switchSprites('active')
    Game.quads.bird.activeFrame = 1
    Game.quads.bird.posX = love.graphics.getWidth() / 2
    Game.quads.bird.posY = love.graphics.getHeight() / 2.6
    Game.quads.bird.physics.body:setX(Game.quads.bird.posX)
    Game.quads.bird.physics.body:setY(Game.quads.bird.posY)
    Game.assets.drawables.floor.posX = 0.0
    Game.quads.pipes.pos.X = love.graphics:getWidth() + ({Game.quads.pipes.pps:getViewport()})[3] / 2

    Game.draw()
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.interface.title, love.graphics.getWidth() / 2, love.graphics.getHeight() / 5, 0, 0.4, 0.4, ({Game.quads.interface.title:getViewport()})[3] / 2, ({Game.quads.interface.title:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.interface.buttons.play, love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.quads.interface.buttons.play:getViewport()})[3] / 2, ({Game.quads.interface.buttons.play:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.interface.buttons.board, 3 * love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.quads.interface.buttons.board:getViewport()})[3] / 2, ({Game.quads.interface.buttons.board:getViewport()})[4] / 2)
end

function Menu.showPauseMenu()
    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.buttons.tap, love.graphics.getWidth() / 2, 1.8 * love.graphics.getHeight() / 3, 0, 0.5, 0.5, ({Game.quads.interface.buttons.tap:getViewport()})[3] / 2, ({Game.quads.interface.buttons.tap:getViewport()})[4] / 2)
end

function Menu.showGetStartedMenu()
    local activeNumber = math.floor(Game.conf.getstarted.time + 1)

    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.numbers[activeNumber], love.graphics:getWidth() / 2, 200, 0, 0.4, 0.4, ({Game.quads.interface.numbers[activeNumber]:getViewport()})[3] / 2, ({Game.quads.interface.numbers[activeNumber]:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.caption, love.graphics.getWidth() / 2, love.graphics.getHeight() / 5, 0, 0.4, 0.4, ({Game.quads.interface.title:getViewport()})[3] / 2, ({Game.quads.interface.title:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.buttons.tap, love.graphics.getWidth() / 2, 1.8 * love.graphics.getHeight() / 3, 0, 0.5, 0.5, ({Game.quads.interface.buttons.tap:getViewport()})[3] / 2, ({Game.quads.interface.buttons.tap:getViewport()})[4] / 2)
end

function Menu.showLossMenu()
    Game.conf.lost = true
    if Game.conf.played == false then Game.assets.sounds.lost:play() Game.conf.played = true end
    
    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.gameOver, love.graphics.getWidth() / 2, love.graphics.getHeight() / 5, 0, 0.4, 0.4, ({Game.quads.interface.title:getViewport()})[3] / 2, ({Game.quads.interface.title:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.active, Game.quads.interface.scoreBoard, love.graphics.getWidth() / 2, love.graphics.getHeight() / 3, 0, 0.4, 0.4, ({Game.quads.interface.gameOver:getViewport()})[3] / 2, ({Game.quads.interface.gameOver:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.interface.buttons.play, love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.quads.interface.buttons.play:getViewport()})[3] / 2, ({Game.quads.interface.buttons.play:getViewport()})[4] / 2)
    love.graphics.draw(Game.assets.drawables.sprites.current, Game.quads.interface.buttons.board, 3 * love.graphics.getWidth() / 4, 2.7 * love.graphics.getHeight() / 4, 0, 0.35, 0.35, ({Game.quads.interface.buttons.board:getViewport()})[3] / 2, ({Game.quads.interface.buttons.board:getViewport()})[4] / 2)
end

return Menu