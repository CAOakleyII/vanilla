local Layout = require 'packages.luigi.layout';
local NetworkMessageTypes = require 'lib.network_message_types';
local CharacterTypes = require 'lib.character_types';
local Player = require 'lib.player';


local character_select = Layout   {
    {
      flow = 'y',
      {
        flow = 'x',
        {},
        {
          flow = 'y',
          {},
          {
            id = 'txtName',
            type = 'text',
            text = 'Name'
          }
        },
        {}
      },
      {
        flow = 'x',
        {},
        {
          flow = 'x',
          id = 'characterSelect',
          style = 'character_select_screen',
          {
            type = 'button',
            id = 'btnWarrior',
            text = 'Warrior',
            height = 32,
            style = 'chararcter_button'
          },
          {
           type = 'button',
           id = 'btnMage',
           text = 'Mage',
           height = 32,
           style = 'chararcter_button'
         },
         {
            type = 'button',
            id = 'btnRanger',
            text = 'Ranger',
            height = 32,
            style = 'chararcter_button'
          }
        },
        {}
      },
      {}
    }
  };

character_select.id = 'characterSelect';

local character_select_style = {
  character_select_screen = {

  },
  chararcter_button = {
    align = 'center middle'
  }
}

character_select:setStyle(character_select_style);

character_select.btnWarrior:onPress(function (event)
  client:connect({
    name =  character_select.txtName.value,
    character = CharacterTypes.Warrior
  });
  client.player:load(true);
  view_manager:hide(character_select);
end)

character_select.btnMage:onPress(function (event)
  client:connect({
    name = character_select.txtName.value,
    character = CharacterTypes.Mage
  });
  client.player:load(true);
  view_manager:hide(character_select);
end)

character_select.btnRanger:onPress(function (event)
  client:connect({
    name = character_select.txtName.value,
    character = CharacterTypes.Ranger
  });
  client.player:load(true);
  view_manager:hide(character_select);
end)

return character_select;
