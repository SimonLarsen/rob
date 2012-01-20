function love.conf(t)
    t.title = "Herbie and Jamal's Super Rob You Now Adventures"
    t.author = "We need a name"
    t.identity = "herbieandjamal"
    t.version = 0.72
    t.console = false
    --t.screen.width = 800
    --t.screen.height = 600
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0

    t.modules.joystick = false
    t.modules.physics = false
end
