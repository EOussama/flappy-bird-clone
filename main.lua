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
local Game = require("modules.game")
local Menu = require("modules.menu")

function love.load()
    Game.init()
end

function love.update(dt)
    if Game.getstarted.state == true then Game.getStarted(dt) return nil end
    if Game.started == false then return nil end
    if Game.paused == true then Game.switchSprites('paused') return nil else Game.switchSprites('active') end
    if Game.bird.posY >= 544 then Game.lost = true return nil end
    if Game.lost == true then return nil end
    if Game.floor.floorX <= -30.0 then Game.floor.floorX = 0.0 end
    Game.floor.floorX = Game.floor.floorX - 0.1
    Game.physicsWorld:update(dt)

    Game.bird.time = Game.bird.time - dt
    if Game.bird.time <= 0 then
        Game.bird.time = 1 / Game.bird.fps
        if Game.bird.swing == true then
            Game.bird.activeFrame = Game.bird.activeFrame + 1
            if Game.bird.activeFrame == 4 then
                Game.bird.activeFrame = 1
                Game.bird.swing = false
            end
        end
    end
end

function love.draw()
    Game.draw()

    if Game.started == false and Game.getstarted.state == false then Menu.showMainMenu() end
    if Game.getstarted.state == true then Menu.showGetStartedMenu() return nil end
    if Game.started == true and Game.paused == true then Menu.showPauseMenu() end
    if Game.lost == true then Menu.showLossMenu() end
end

function love.focus(focus)
    if Game.lost == false and Game.started == true and Game.getstarted.state == false then
        if focus == false then Game.paused = true end
    end
end

-- Input handling
function love.keypressed(key , scancode , isrepeat )
    if key == 'p' then
        if Game.lost == false and Game.started == true and Game.getstarted.state == false then
            Game.paused = not Game.paused
        end
    elseif key == 'space' then
        if Game.started == false and Game.getstarted.state == false then
            Game.getstarted.state = true
        elseif Game.started == true and Game.getstarted.state == false then
            Game.birdFly()
        end
    elseif key == 'escape' then
        if Game.started == true then
            Game.started = false
        elseif Game.getstarted.state == true then
            Game.getstarted.state = false
            Game.started = false
        end
    end
end

function love.mousepressed(mx , my , button)
    if (Game.started == false or Game.lost == true) and Game.getstarted.state == false and button == 1 then
        if (mx >= 59 and mx < 142) and (my >= 447 and my < 493) then
            Menu.showMainMenu()
            Game.getstarted.state = true
        elseif (mx >= 259 and mx < 642) and (my >= 447 and my < 493) then
            -- Board button
        end
    elseif Game.started == true and button == 1 and Game.getstarted.state == false then
        Game.birdFly()
    end
end