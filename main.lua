-- collision-pi-visualizer
-- (c) Vilhelm Prytz <vilhelm@prytznet.se> 2019

-- digits of pi
d = 2

collisions = 0

-- left square
left_square = {}
left_square.x = 200
left_square.mass = 1
left_square.velocity = 0

-- right square
right_square = {}
right_square.x = 500
right_square.mass = math.pow(100, d-1)
right_square.velocity = -0.5

-- other
block_y = love.graphics.getHeight()/2
square_size = 50

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

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw squares
    love.graphics.setColor(255, 0, 0) -- red
    love.graphics.rectangle("fill", left_square.x, block_y, square_size, square_size)

    love.graphics.setColor(0, 0, 255) -- blue
    love.graphics.rectangle("fill", right_square.x, block_y, square_size, square_size)

    -- display amount of collisions
    love.graphics.setColor(255, 255, 255) -- white
    love.graphics.print("Collisions: " .. tostring(collisions), 10, 10, 0, 1, 1)

    -- fps
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 25, 0, 1, 1)
end

function love.update(dt)
    left_square.x = left_square.x + (left_square.velocity)
    right_square.x = right_square.x + (right_square.velocity)

    -- check collision
    if (right_square.x <= left_square.x+square_size) then
        collision()
    end

    if (left_square.x < 0) then
        wall_collision()
    end
end
