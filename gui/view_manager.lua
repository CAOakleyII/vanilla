ViewManager = {
  layouts = {}
};

ViewManager.__index = ViewManager;

-- Constructor
--
--
function ViewManager:new(obj)
  obj = obj or {};
  setmetatable(obj, ViewManager);
  return obj;
end

function ViewManager:show(layout)
  if layout then
    layout.showView = true;
    self.layouts[layout.id] = layout;
  else
    for id, l in pairs(self.layouts) do
        if l.showView then
          l:show();
        end
    end
  end
end

function ViewManager:hide(layout)
    if layout then
      layout.showView = false;
      layout:hide();
      self.layouts[layout.id] = layout;
  end
end

return ViewManager;
