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
local Menu = require("modules/menu")

function love.load()
    Game.init()
end

function love.update(dt)
    if Game.started == false then return nil end
    if Game.paused == true then Game.switchSprites('paused') return nil else Game.switchSprites('active') end

    Game.bird.time = Game.bird.time - dt
    if Game.bird.time <= 0 then
        Game.bird.time = 1 / Game.bird.fps

        if Game.bird.activeFrame == 3 then Game.bird.activeFrame = 1 end
        Game.bird.activeFrame = Game.bird.activeFrame + 1
    end
end

function love.draw()
    love.graphics.draw(Game.background.current, 0, -Game.floor.current:getHeight() / 10)
    love.graphics.draw(Game.floor.current, 0, love.graphics.getHeight() - Game.floor.current:getHeight() / 2, 0, 0.5, 0.5)
    love.graphics.draw(Game.sprites.current, Game.bird.frames[Game.bird.activeFrame], love.graphics.getWidth() / 2, love.graphics.getHeight() / 2.6, 0, 0.6, 0.6, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[3] / 2, ({Game.bird.frames[Game.bird.activeFrame]:getViewport()})[4] / 2)

    if Game.started == false then Menu.showMainMenu() end
    if Game.started == true and Game.paused == true then Menu.showPauseMenu() end
end

function love.focus(focus)
    if focus == false then Game.paused = true end
end

function love.quit()
    print("Game ended!")
end

-- Input handling
function love.keypressed(key , scancode , isrepeat )
    if key == 'p' then
        if Game.started == false then
            Game.started = not Game.started
        else
            Game.paused = not Game.paused
        end
    elseif key == 'space' then
        Game.birdFly()
    elseif key == 'escape' then
        if Game.started == true then Game.started = false end
    end
end

function love.mousepressed(mx , my , button)
    if Game.started == false and button == 1 then
        if (mx >= 59 and mx < 142) and (my >= 447 and my < 493) then
            Game.started = true
        elseif (mx >= 259 and mx < 642) and (my >= 447 and my < 493) then
            -- Board button
        end
    else
        -- Move the bird up

        Game.birdFly()
    end
end