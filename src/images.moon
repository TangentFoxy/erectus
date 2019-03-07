images = {}
for img in *love.filesystem.getDirectoryItems "img"
  images[img] = love.graphics.newImage "img/#{img}"
images
