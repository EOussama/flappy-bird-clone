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

    speed = 1

    if Game.conf.getstarted.state == true then Game.getStarted(dt) return nil end
    if Game.conf.started == false then return nil end
    if Game.conf.paused == true then Game.switchSprites('paused') return nil else Game.switchSprites('active') end
    if Game.quads.bird.posY >= 544 then Game.conf.lost = true return nil end
    if Game.conf.lost == true then return nil end
    if Game.assets.drawables.floor.posX <= -30.0 then Game.assets.drawables.floor.posX = 0.0 end
    Game.assets.drawables.floor.posX = Game.assets.drawables.floor.posX - speed
    Game.physics.physicsWorld:update(dt)

    if Game.quads.pipes.pos.X < -({Game.quads.pipes.pps:getViewport()})[3] then Game.quads.pipes.pos.X = love.graphics:getWidth() + ({Game.quads.pipes.pps:getViewport()})[3] / 2 end
    Game.quads.pipes.pos.X = Game.quads.pipes.pos.X - speed

    Game.quads.bird.time = Game.quads.bird.time - dt
    if Game.quads.bird.time <= 0 then
        Game.quads.bird.time = 1 / Game.quads.bird.fps
        if Game.quads.bird.swing == true then
            Game.quads.bird.activeFrame = Game.quads.bird.activeFrame + 1
            if Game.quads.bird.activeFrame == 4 then
                Game.quads.bird.activeFrame = 1
                Game.quads.bird.swing = false
            end
        end
    end
end

function love.draw()
    Game.draw()

    if Game.conf.started == false and Game.conf.getstarted.state == false then Menu.showMainMenu() end
    if Game.conf.getstarted.state == true then Menu.showGetStartedMenu() return nil end
    if Game.conf.started == true and Game.conf.paused == true then Menu.showPauseMenu() end
    if Game.conf.lost == true then Menu.showLossMenu() end
end

function love.focus(focus)
    if Game.conf.lost == false and Game.conf.started == true and Game.conf.getstarted.state == false then
        if focus == false then Game.conf.paused = true end
    end
end

-- Input handling
function love.keypressed(key, scancode, isrepeat)
    if key == 'p' then
        if Game.conf.lost == false and Game.conf.started == true and Game.conf.getstarted.state == false then
            Game.conf.paused = not Game.conf.paused
        end
    elseif key == 'space' then
        if Game.conf.started == false and Game.conf.getstarted.state == false then
            Menu.showMainMenu()
            Game.conf.getstarted.state = true
        elseif Game.conf.started == true and Game.conf.getstarted.state == false then
            Game.birdFly()
        end
    elseif key == 'escape' then
        if Game.conf.started == true then
            Game.conf.started = false
        elseif Game.conf.getstarted.state == true then
            Game.conf.getstarted.state = false
            Game.conf.started = false
        end
    end
end

function love.mousepressed(mx , my , button)
    if (Game.conf.started == false or Game.conf.lost == true) and Game.conf.getstarted.state == false and button == 1 then
        if (mx >= 59 and mx < 142) and (my >= 447 and my < 493) then
            Menu.showMainMenu()
            Game.conf.getstarted.state = true
        elseif (mx >= 259 and mx < 642) and (my >= 447 and my < 493) then
            -- Board button
        end
    elseif Game.conf.started == true and button == 1 and Game.conf.getstarted.state == false then
        Game.birdFly()
    end
end
