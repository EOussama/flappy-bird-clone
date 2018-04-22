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


function love.conf(t)
    -- Love2D configuration
    t.version = '11.0'
    --t.console = true

    -- Game information
    t.window.title = "Flappy Bird clone"
    t.window.icon = "assets/drawables/icon.png"
    t.window.display = 1
    t.window.width = 400
    t.window.height = 700

    -- Modules
    t.modules.joystick = false
    t.modules.thread = false  
    t.modules.touch = false   
    t.modules.video = false   
    t.modules.data = false    
end