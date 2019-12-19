-- collision-pi-visualizer
-- (c) Vilhelm Prytz <vilhelm@prytznet.se> 2019

local utf8 = require("utf8")

-- digits of pi
digits = ""

collisions = 0

-- left square
left_square = {}
left_square.x = 200
left_square.mass = 1
left_square.velocity = 0

-- right square
right_square = {}
right_square.x = 700
right_square.velocity = -0.5

-- other
block_y = love.graphics.getHeight()/2
square_size = 50

-- state
state = {}
state.running = false

function collision()
    collisions = collisions+1

    v1 = right_square.velocity
    v2 = left_square.velocity
    m1 = right_square.mass
    m2 = left_square.mass

    -- conservation of momentum & completely elastic collision
    right_square.velocity = (v1 * (m1 - m2) + 2 * m2 * v2)/(m1 + m2)
    left_square.velocity = (v2 * (m2 - m1) + 2 * m1 * v1)/(m2 + m1)
end

function wall_collision()
    collisions = collisions+1

    left_square.velocity = -(left_square.velocity)
end

function love.textinput(t)
    if tonumber(t) ~= nil then
        digits = tostring(digits .. t)
    end
end

function love.keypressed(key)
    if key == "return" then
        -- set mass
        right_square.mass = math.pow(100, tonumber(digits)-1)

        -- set squares
        left_square.x = 200
        left_square.velocity = 0
        right_square.x = 700
        right_square.velocity = -0.5

        -- reset
        collisions = 0
        digits = ""

        -- running
        state.running = true
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw squares
    love.graphics.setColor(255, 0, 0) -- red
    love.graphics.rectangle("fill", left_square.x, block_y, square_size, square_size)

    love.graphics.setColor(0, 0, 255) -- blue
    love.graphics.rectangle("fill", right_square.x, block_y, square_size, square_size)

    -- display amount of collisions
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.setColor(255, 255, 255) -- white
    love.graphics.print("Collisions: " .. tostring(collisions), 10, 10, 0, 1, 1)

    -- fps
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25, 0, 1, 1)

    -- enter digits of pi
    love.graphics.setFont(love.graphics.newFont(36))
    if (state.running == false) then
        love.graphics.print("Enter digits of Pi: "..tostring(digits), 250, 250, 0, 1, 1)
    end
end

function love.update(dt)
    if (state.running == true) then
        left_square.x = left_square.x + (left_square.velocity)
        right_square.x = right_square.x + (right_square.velocity)
    end

    -- check collision
    if (right_square.x <= left_square.x+square_size) then
        collision()
    end

    if (left_square.x < 0) then
        wall_collision()
    end

    -- check if both are outside screen
    if (left_square.x > 800 and right_square.x > 800) then
        state.running = false
    end
end
