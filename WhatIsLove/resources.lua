font = {}

--- Load resources used during the game
function loadResources()
  font.bold = love.graphics.newImageFont(
    "img/boldfont.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!'-:*@<>+/_$&?",
    2
  )
  love.graphics.setFont(font.bold)
end
