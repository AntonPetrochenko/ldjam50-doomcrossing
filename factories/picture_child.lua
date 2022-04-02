local picture_child = require('factories.pictureobject')

return function (...)
  local new_picture = picture_child(...)

  new_picture.extra_update = function (self)
    self.x = self.x + 1
  end

  return new_picture
end