-- Open Clover
-- An Open Source Port of the SNES Classic Edition Front End Written With LÖVE
----------------------------------------------------------------------------------------------------------------------

function love.load()

----------------------------------------------------------------------------------------------------------------------
  -- Set window title, resolution, and default filter
  love.window.setTitle("Clover")
  love.window.setMode(1280, 720, {vsync = true})
  love.graphics.setDefaultFilter("nearest", "nearest", 1)

  -- Load small, medium, and large fonts
  small_font = love.graphics.newFont("font/system.ttf", 18)
  medium_font = love.graphics.newFont("font/system.ttf", 24)
  large_font = love.graphics.newFont("font/system.ttf", 36)

  -- Load all image resources
  carousel_background_image = love.graphics.newImage("image/background/carousel.png")
  top_menubar_banner_image = love.graphics.newImage("image/banner/menubar/top.png")
  display_icon_image = love.graphics.newImage("image/icon/display.png")
  setting_icon_image = love.graphics.newImage("image/icon/setting.png")
  language_icon_image = love.graphics.newImage("image/icon/language.png")
  legal_icon_image = love.graphics.newImage("image/icon/legal.png")
  manual_icon_image = love.graphics.newImage("image/icon/manual.png")
  banner_caption_image = love.graphics.newImage("image/caption/banner.png")
  off_card_image = love.graphics.newImage("image/card/off.png")
  on_card_image = love.graphics.newImage("image/card/on.png")
  mask_card_image = love.graphics.newImage("image/card/mask.png")
  suspend_active_off_card_icon_image = love.graphics.newImage("image/icon/card/on/active/suspend.png")
  suspend_active_on_card_icon_image = love.graphics.newImage("image/icon/card/off/active/suspend.png")
  suspend_empty_off_card_icon_image = love.graphics.newImage("image/icon/card/off/empty/suspend.png")
  suspend_empty_on_card_icon_image = love.graphics.newImage("image/icon/card/on/empty/suspend.png")
  sram_card_icon_image = love.graphics.newImage("image/icon/card/sram.png")
  one_player_card_icon_image = love.graphics.newImage("image/icon/card/player/two.png")
  two_player_card_icon_image = love.graphics.newImage("image/icon/card/player/two.png")
  thumbnail_cursor_image = love.graphics.newImage("image/cursor/thumbnail.png")
  square_frame_cursor_image = love.graphics.newImage("image/cursor/frame/square.png")
  normal_bubble_caption_image = love.graphics.newImage("image/caption/bubble/normal.png")
  long_bubble_caption_image = love.graphics.newImage("image/caption/bubble/long.png")
  round_frame_cursor_image = love.graphics.newImage("image/cursor/frame/round.png")
  up_dpad_icon_image = love.graphics.newImage("image/icon/dpad/up.png")
  down_dpad_icon_image = love.graphics.newImage("image/icon/dpad/down.png")
  horizontal_dpad_icon_image = love.graphics.newImage("image/icon/dpad/horizontal.png")
  select_outline_button_icon_image = love.graphics.newImage("image/icon/button/outline/select.png")
  start_outline_button_icon_image = love.graphics.newImage('image/icon/button/outline/start.png')
  bottom_menubar_banner_image = love.graphics.newImage("image/banner/menubar/bottom.png")
  option_background_image = love.graphics.newImage("image/background/option.png")
  normal_dpad_icon_image = love.graphics.newImage("image/icon/dpad/normal.png")
  a_outline_button_icon_image = love.graphics.newImage("image/icon/button/outline/a.png")
  b_outline_button_icon_image = love.graphics.newImage("image/icon/button/outline/b.png")
  b_normal_button_icon_image = love.graphics.newImage("image/icon/button/normal/b.png")
  horizontal_cursor_image = love.graphics.newImage("image/cursor/horizontal.png")
  off_radio_button_image = love.graphics.newImage("image/button/radio/off.png")
  on_radio_button_image = love.graphics.newImage("image/button/radio/on.png")
  off_dialog_button_image = love.graphics.newImage("image/button/dialog/off.png")
  on_dialog_button_image = love.graphics.newImage("image/button/dialog/on.png")
  bottom_suspend_banner_image = love.graphics.newImage("image/banner/suspend/bottom.png")
  tail_suspend_banner_image = love.graphics.newImage("image/banner/suspend/tail.png")
  suspend_icon_image = love.graphics.newImage("image/icon/suspend.png")
  first_slot_icon_image = love.graphics.newImage("image/icon/slot/first.png")
  second_slot_icon_image = love.graphics.newImage("image/icon/slot/second.png")
  third_slot_icon_image = love.graphics.newImage("image/icon/slot/third.png")
  fourth_slot_icon_image = love.graphics.newImage("image/icon/slot/fourth.png")
  suspend_slot_image = love.graphics.newImage("image/slot/suspend.png")
  explanation_caption_image = love.graphics.newImage("image/caption/explanation.png")

  -- Load all sound resources
  intro_background_sound = love.audio.newSource("sound/background/intro.ogg", "static")
  loop_background_sound = love.audio.newSource("sound/background/loop.ogg", "static")
  click_effect_sound = love.audio.newSource("sound/effect/click.ogg", "static")
  cancel_effect_sound = love.audio.newSource("sound/effect/cancel.ogg", "static")
  cursor_effect_sound = love.audio.newSource("sound/effect/cursor.ogg", "static")
  intro_background_sound:play()

  -- Load all string resources
  english_string = love.filesystem.load("string/english.str")()
  french_string = love.filesystem.load("string/french.str")()
  german_string = love.filesystem.load("string/german.str")()
  spanish_string = love.filesystem.load("string/spanish.str")()
  italian_string = love.filesystem.load("string/italian.str")()
  dutch_string = love.filesystem.load("string/dutch.str")()
  portuguese_string = love.filesystem.load("string/portuguese.str")()
  russian_string = love.filesystem.load("string/russian.str")()

  -- Load all needed modules
  serialize_module = require "module/serialize"
  tween_module = require "module/tween"
  animation_module = require "module/anim8"

----------------------------------------------------------------------------------------------------------------------

  -- Set main configuration
  if love.filesystem.getInfo("configuration.ini") then
    configuration = love.filesystem.load("configuration.ini")()
  else
    configuration = {string = "english_string", setup_completed = false}
  end

  -- Set user game list
  gamelist = love.filesystem.load("user/gamelist.ini")()

  -- Set carousel scene variables
  carousel_key_held_counter = 0
  carousel_is_in_options = false
  carousel_is_leaving_options = false
  carousel_background_position_x = 0
  carousel_background_position_speed = 0
  carousel_background_tween = { x = 0 }
  carousel_background_x_direction = "right"
  carousel_top_banner_position = {y = -5}
  carousel_top_banner_selection_box_alpha = 0
  carousel_display_icon_scale = {factor = 1}
  carousel_setting_icon_scale = {factor = 1}
  carousel_language_icon_scale = {factor = 1}
  carousel_legal_icon_scale = {factor = 1}
  carousel_manual_icon_scale = {factor = 1}
  carousel_x_index = 0
  carousel_cards_x_position = {}
  carousel_position_counter = 0
  for k in pairs(gamelist) do
    carousel_cards_x_position[carousel_position_counter] = -262 + (carousel_position_counter * 262)
    gamelist[carousel_position_counter].image = love.graphics.newImage("user/" .. gamelist[carousel_position_counter].boxart)
    gamelist[carousel_position_counter].on_alpha = 0
    carousel_position_counter = carousel_position_counter + 1
  end
  carousel_first_card = 0
  carousel_last_card = carousel_position_counter - 1
  carousel_position = {x = -141 + 262 * 2}
  carousel_cursor_x_index = 0
  carousel_cursor_position = {x = 118}
  carousel_cursor_rectangle_position = {x = 118, y = 219, width = 258, height = 282}
  carousel_bubble_caption_scale = {factor = 0}
  carousel_option_x_index = 0
  carousel_bubble_caption_timer = 0
  carousel_bubble_caption_timer_set = false
  carousel_bubble_caption_x_offset = 0
  carousel_thumbnail_cursor_grid = animation_module.newGrid(32, 18, 128, 18)
  carousel_thumbnail_cursor_animation = animation_module.newAnimation(carousel_thumbnail_cursor_grid("1-4", 1), 0.11)

  -- Set suspend point scene variables
  no_suspend_background_position = { y = 750}
  no_suspend_cards_position = { y = 0}
  no_suspend_banner_caption_position = { y = 0}
  mask_card = {alpha = 0}
  no_suspend_explanation_timer = 0
  no_suspend_explanation = { alpha = 1 }
  no_suspend_explanation_transition = tween_module.new(1, no_suspend_explanation, {alpha = 0}, "linear")

  -- Set language scene variables
  language_key_held_counter = 0
  language_scene_position = { y = 0 }
  language_horizontal_cursor_grid = animation_module.newGrid(24, 24, 96, 24)
  language_horizontal_cursor_animation = animation_module.newAnimation(language_horizontal_cursor_grid("1-4", 1), 0.11)
  language_selection_box_x_offset = 0
  language_selection_box_y_offset = 0
  language_on_radio_button_x_position = 202
  language_on_radio_button_y_position = 162
  language_on_dialog_button_alpha = 0

  -- Set independent variables
  if configuration.setup_completed == false then
    current_scene = "language"
  else
    current_scene = "carousel"
    language_scene_position.y = -720
  end

  -- Move carousel to correct location
  gamelist[(carousel_first_card + carousel_cursor_x_index) % carousel_position_counter].on_alpha = 1
  carousel_cards_x_position[carousel_last_card] = carousel_cards_x_position[carousel_first_card] - 262
  carousel_first_card = (carousel_first_card - 1) % carousel_position_counter
  carousel_last_card = (carousel_last_card - 1) % carousel_position_counter
  carousel_x_index = carousel_x_index + 1
  carousel_cards_x_position[carousel_last_card] = carousel_cards_x_position[carousel_first_card] - 262
  carousel_first_card = (carousel_first_card - 1) % carousel_position_counter
  carousel_last_card = (carousel_last_card - 1) % carousel_position_counter
  carousel_x_index = carousel_x_index + 1

----------------------------------------------------------------------------------------------------------------------

end

function love.update(dt)

----------------------------------------------------------------------------------------------------------------------

  -- Update carousel scene input
  if current_scene == "carousel" then
    if love.keyboard.isDown("right") then
      if carousel_is_in_options == false then
        if carousel_key_held_counter == 0 or (carousel_key_held_counter >= 12 and carousel_key_held_counter % 6 == 0) then
          if carousel_cursor_x_index ~= 3 then
            carousel_cursor_x_index = carousel_cursor_x_index + 1
            carousel_cursor_x_transition = tween_module.new(0.3, carousel_cursor_position, {x = 118 + carousel_cursor_x_index * 262}, "outExpo")
            carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 118 + carousel_cursor_x_index * 262}, "outExpo")
          else
            carousel_background_x_direction = "right"
            if carousel_background_position_speed < 12 then
              carousel_background_position_speed = carousel_background_position_speed + 0.75
            end
            carousel_cards_x_position[carousel_first_card] = carousel_cards_x_position[carousel_last_card] + 262
            carousel_first_card = (carousel_first_card + 1) % carousel_position_counter
            carousel_last_card = (carousel_last_card + 1) % carousel_position_counter
            carousel_x_index = carousel_x_index - 1
            if carousel_key_held_counter == 0 then
              carousel_x_transition = tween_module.new(0.25, carousel_position, {x = -141 + carousel_x_index * 262}, "linear")
              carousel_background_x_transition = tween_module.new(1, carousel_background_tween, { x = carousel_background_tween.x -  64}, "outQuart")
            elseif carousel_key_held_counter >= 12 then
              carousel_x_transition = tween_module.new(0.15, carousel_position, {x = -141 + carousel_x_index * 262}, "linear")
            end
          end
          cursor_effect_sound:play()
        end
      elseif carousel_is_leaving_options == false then
        if carousel_key_held_counter == 0 or (carousel_key_held_counter >= 15 and carousel_key_held_counter % 13 == 0) then
          if carousel_option_x_index < 4  then
            carousel_option_x_index = carousel_option_x_index + 1
          else
            carousel_option_x_index = 0
          end
          carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 394 + carousel_option_x_index * 96}, "outExpo")
          if carousel_option_x_index == 0 then
            carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1.2}, "outQuart")
            carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 1 then
            carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1.2}, "outQuart")
            carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 2 then
            carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1.2}, "outQuart")
            carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 3 then
            carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1.2}, "outQuart")
            carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 4 then
            carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1.2}, "outQuart")
            carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1}, "inQuart")
          end
          cursor_effect_sound:play()
          carousel_bubble_caption_timer = 0
          carousel_bubble_caption_timer_set = true
        end
      end
      carousel_key_held_counter = carousel_key_held_counter + 1
    elseif love.keyboard.isDown("left") then
      if carousel_is_in_options == false then
        if carousel_key_held_counter == 0 or (carousel_key_held_counter >= 12 and carousel_key_held_counter % 6 == 0) then
          if carousel_cursor_x_index ~= 0 then
            carousel_cursor_x_index = carousel_cursor_x_index - 1
            carousel_cursor_x_transition = tween_module.new(0.3, carousel_cursor_position, {x = 118 + carousel_cursor_x_index * 262}, "outExpo")
            carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 118 + carousel_cursor_x_index * 262}, "outExpo")
          else
            carousel_background_x_direction = "left"
            if carousel_background_position_speed > -12 then
              carousel_background_position_speed = carousel_background_position_speed - 0.75
            end
            carousel_cards_x_position[carousel_last_card] = carousel_cards_x_position[carousel_first_card] - 262
            carousel_first_card = (carousel_first_card - 1) % carousel_position_counter
            carousel_last_card = (carousel_last_card - 1) % carousel_position_counter
            carousel_x_index = carousel_x_index + 1
            if carousel_key_held_counter == 0 then
              carousel_x_transition = tween_module.new(0.25, carousel_position, {x = -141 + carousel_x_index * 262}, "linear")
              carousel_background_x_transition = tween_module.new(1, carousel_background_tween, { x = carousel_background_tween.x +  64}, "outQuart")
            elseif carousel_key_held_counter >= 12 then
              carousel_x_transition = tween_module.new(0.15, carousel_position, {x = -141 + carousel_x_index * 262}, "linear")
            end
          end
          cursor_effect_sound:play()
        end
      elseif carousel_is_leaving_options == false then
        if carousel_key_held_counter == 0 or (carousel_key_held_counter >= 15 and carousel_key_held_counter % 13 == 0) then
          if carousel_option_x_index > 0  then
            carousel_option_x_index = carousel_option_x_index - 1
          else
            carousel_option_x_index = 4
          end
          carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 394 + carousel_option_x_index * 96}, "outExpo")
          if carousel_option_x_index == 0 then
            carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1.2}, "outQuart")
            carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 1 then
            carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1.2}, "outQuart")
            carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 2 then
            carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1.2}, "outQuart")
            carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 3 then
            carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1.2}, "outQuart")
            carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1}, "inQuart")
          elseif carousel_option_x_index == 4 then
            carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1.2}, "outQuart")
            carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1}, "inQuart")
          end
          cursor_effect_sound:play()
          carousel_bubble_caption_timer = 0
          carousel_bubble_caption_timer_set = true
        end
      end
      carousel_key_held_counter = carousel_key_held_counter + 1
    else
      if carousel_background_position_speed > 0.75 then
        carousel_background_position_speed = carousel_background_position_speed - 0.4
      elseif carousel_background_position_speed < - 0.75 then
          carousel_background_position_speed = carousel_background_position_speed + 0.4
      else
        carousel_background_position_speed = 0
      end
      carousel_key_held_counter = 0
    end
    function love.keypressed(key)
      if current_scene == "carousel" then
        if key == "up" then
          if carousel_is_in_options == false then
            cursor_effect_sound:play()
            carousel_bubble_caption_timer_set = true
            carousel_bubble_caption_timer = 0
            carousel_top_banner_selection_box_alpha = 255
            carousel_is_in_options = true
            carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 394 + carousel_option_x_index * 96}, "outExpo")
            carousel_cursor_rectangle_y_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {y = 26}, "outExpo")
            carousel_cursor_rectangle_width_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {width = 108}, "outExpo")
            carousel_cursor_rectangle_height_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {height = 82}, "outExpo")
            carousel_top_banner_y_transition = tween_module.new(0.2, carousel_top_banner_position, {y = 0}, "linear")
            if carousel_option_x_index == 0 then
              carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1.2}, "outQuart")
            elseif carousel_option_x_index == 1 then
              carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1.2}, "outQuart")
            elseif carousel_option_x_index == 2 then
              carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1.2}, "outQuart")
            elseif carousel_option_x_index == 3 then
              carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1.2}, "outQuart")
            elseif carousel_option_x_index == 4 then
              carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1.2}, "outQuart")
            end
          end
        elseif key == "down" or key == "z" then
          if carousel_is_in_options == true then
            carousel_top_banner_selection_box_alpha = 0
            carousel_cursor_rectangle_x_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {x = 118 + carousel_cursor_x_index * 262}, "outExpo")
            carousel_cursor_rectangle_y_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {y = 219}, "outExpo")
            carousel_cursor_rectangle_width_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {width = 258}, "outExpo")
            carousel_cursor_rectangle_height_transition = tween_module.new(0.3, carousel_cursor_rectangle_position, {height = 282}, "outExpo")
            carousel_top_banner_y_transition = tween_module.new(0.2, carousel_top_banner_position, {y = -5}, "linear")
            if carousel_is_leaving_options == false then
              cursor_effect_sound:play()
              carousel_bubble_caption_timer_set = true
              carousel_bubble_caption_timer = 0
              if carousel_option_x_index == 0 then
                carousel_display_icon_scale_transition = tween_module.new(0.2, carousel_display_icon_scale, {factor = 1}, "inQuart")
              elseif carousel_option_x_index == 1 then
                carousel_setting_icon_scale_transition = tween_module.new(0.2, carousel_setting_icon_scale, {factor = 1}, "inQuart")
              elseif carousel_option_x_index == 2 then
                carousel_language_icon_scale_transition = tween_module.new(0.2, carousel_language_icon_scale, {factor = 1}, "inQuart")
              elseif carousel_option_x_index == 3 then
                carousel_legal_icon_scale_transition = tween_module.new(0.2, carousel_legal_icon_scale, {factor = 1}, "inQuart")
              elseif carousel_option_x_index == 4 then
                carousel_manual_icon_scale_transition = tween_module.new(0.2, carousel_manual_icon_scale, {factor = 1}, "inQuart")
              end
            end
            carousel_is_leaving_options = true
          end
        end
        if key == "down" and carousel_is_in_options == false then
          current_scene = "suspend"
          no_suspend_background_y_transition =  tween_module.new (0.25, no_suspend_background_position, {y = 720 - 351}, "outExpo")
          no_suspend_banner_caption_transition = tween_module.new (0.175, no_suspend_banner_caption_position, {y = -52}, "linear")
          no_suspend_cards_y_transition = tween_module.new (0.175, no_suspend_cards_position, {y = -69}, "linear")
          mask_card_alpha_transition = tween_module.new (0.175, mask_card, {alpha = 0.5}, "linear")
          no_suspend_explanation_timer = 0
          no_suspend_explanation.alpha = 1
          no_suspend_explanation_timer_set = true
          if no_suspend_explanation_transition then
            no_suspend_explanation_transition:set(0)
          end
          click_effect_sound:play()
        end
      end
    end

  -- Update suspend points scene input
  elseif current_scene == "suspend" then
    function love.keypressed(key)
      if key == "up" or key == "z" then
        no_suspend_background_y_transition =  tween_module.new (0.2, no_suspend_background_position, {y = 750}, "inQuart")
        no_suspend_banner_caption_transition = tween_module.new (0.175, no_suspend_banner_caption_position, {y = 0}, "linear")
        no_suspend_cards_y_transition = tween_module.new (0.175, no_suspend_cards_position, {y = 0}, "linear")
        mask_card_alpha_transition = tween_module.new (0.175, mask_card, {alpha = 0}, "linear")
        cancel_effect_sound:play()
        current_scene = "carousel"
      end
    end
    if carousel_background_position_speed > 0.75 then
      carousel_background_position_speed = carousel_background_position_speed - 0.4
    elseif carousel_background_position_speed < - 0.75 then
        carousel_background_position_speed = carousel_background_position_speed + 0.4
    else
    carousel_background_position_speed = 0
    carousel_key_held_counter = 0
    end

  -- Update language scene input
  elseif current_scene == "language" then
    if love.keyboard.isDown("right") then
      if language_on_dialog_button_alpha == 0 then
        if language_key_held_counter == 0 or (language_key_held_counter >= 30 and language_key_held_counter % 13 == 0) then
          if language_selection_box_x_offset == 1 then
            language_selection_box_x_offset = 0
          else
            language_selection_box_x_offset = language_selection_box_x_offset  + 1
          end
          cursor_effect_sound:play()
        end
        language_key_held_counter = language_key_held_counter + 1
      end
    elseif love.keyboard.isDown("left") then
      if language_on_dialog_button_alpha == 0 then
        if language_key_held_counter == 0 or (language_key_held_counter >= 30 and language_key_held_counter % 13 == 0) then
          if language_selection_box_x_offset == 0 then
            language_selection_box_x_offset = 1
          else
            language_selection_box_x_offset = language_selection_box_x_offset  - 1
          end
          cursor_effect_sound:play()
        end
        language_key_held_counter = language_key_held_counter + 1
      end
    elseif love.keyboard.isDown("down") then
      if language_key_held_counter == 0 or (language_key_held_counter >= 30 and language_key_held_counter % 13 == 0) then
        if language_selection_box_y_offset == 3 then
          language_selection_box_y_offset = language_selection_box_y_offset + 1
          language_on_dialog_button_alpha = 255
        elseif language_selection_box_y_offset == 4 then
          language_selection_box_y_offset = 0
          language_on_dialog_button_alpha = 0
        else
          language_selection_box_y_offset = language_selection_box_y_offset + 1
        end
        cursor_effect_sound:play()
      end
      language_key_held_counter = language_key_held_counter + 1
    elseif love.keyboard.isDown("up") then
      if language_key_held_counter == 0 or (language_key_held_counter >= 30 and language_key_held_counter % 13 == 0) then
        if language_selection_box_y_offset == 0 then
          language_selection_box_y_offset = 4
          language_on_dialog_button_alpha = 255
        else
          language_selection_box_y_offset = language_selection_box_y_offset - 1
          language_on_dialog_button_alpha = 0
        end
        cursor_effect_sound:play()
      end
      language_key_held_counter = language_key_held_counter + 1
    else
      language_key_held_counter = 0
    end
    function love.keypressed(key)
      if key == "x" then
        if language_selection_box_y_offset ~= 4 then
          if language_selection_box_x_offset == 0 and language_selection_box_y_offset == 0 and configuration.string ~= "english_string" then
            click_effect_sound:play()
            configuration.string = "english_string"
          elseif language_selection_box_x_offset == 0 and language_selection_box_y_offset == 1 and configuration.string ~= "french_string"  then
            click_effect_sound:play()
            configuration.string = "french_string"
          elseif language_selection_box_x_offset == 0 and language_selection_box_y_offset == 2 and configuration.string ~= "german_string"  then
            click_effect_sound:play()
            configuration.string = "german_string"
          elseif language_selection_box_x_offset == 0 and language_selection_box_y_offset == 3 and configuration.string ~= "spanish_string"  then
            click_effect_sound:play()
            configuration.string = "spanish_string"
          elseif language_selection_box_x_offset == 1 and language_selection_box_y_offset == 0 and configuration.string ~= "italian_string"  then
            click_effect_sound:play()
            configuration.string = "italian_string"
          elseif language_selection_box_x_offset == 1 and language_selection_box_y_offset == 1 and configuration.string ~= "dutch_string"  then
            click_effect_sound:play()
            configuration.string = "dutch_string"
          elseif language_selection_box_x_offset == 1 and language_selection_box_y_offset == 2 and configuration.string ~= "portuguese_string"  then
            click_effect_sound:play()
            configuration.string = "portuguese_string"
          elseif language_selection_box_x_offset == 1 and language_selection_box_y_offset ==  3 and configuration.string ~= "russian_string"  then
            click_effect_sound:play()
            configuration.string = "russian_string"
          end
          language_on_radio_button_x_position = (language_selection_box_x_offset * 528) + 202
          language_on_radio_button_y_position = (language_selection_box_y_offset * 96) + 162
          language_on_dialog_button_alpha = 255
          language_selection_box_y_offset = 4
        else
          current_scene = "carousel"
          configuration.setup_completed = true
          language_scene_out_transition = tween_module.new(0.20, language_scene_position, {y = -720}, "inQuart")
          click_effect_sound:play()
        end
      end
    end
  end

  -- Update independent input
  if love.keyboard.isDown("escape") then
    love.filesystem.write("configuration.ini", serialize_module(configuration))
    love.event.push("quit")
  end

----------------------------------------------------------------------------------------------------------------------

  -- Update carousel scene variables
  carousel_start_game_string_x = 1000 - small_font:getWidth(_G[configuration.string].gmTtlLstHudSta)
  carousel_sort_game_string_x = carousel_start_game_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudSrt) - 130
  carousel_suspend_point_string_x = carousel_sort_game_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudSus) - 142
  carousel_menu_string_x = carousel_suspend_point_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudMen) - 83
  carousel_start_game_string_x = ((1280 - (1000 - (carousel_menu_string_x - 46))) / 2) + (1000 - (carousel_menu_string_x - 46)) - (small_font:getWidth(_G[configuration.string].gmTtlLstHudSta))
  carousel_sort_game_string_x = carousel_start_game_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudSrt) - 130
  carousel_suspend_point_string_x = carousel_sort_game_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudSus) - 142
  carousel_menu_string_x = carousel_suspend_point_string_x - small_font:getWidth(_G[configuration.string].gmTtlLstHudMen) - 83
  carousel_background_position_x = carousel_background_position_x - carousel_background_position_speed
  if carousel_background_x_direction == "left" then
    carousel_background_position_x = carousel_background_position_x + 0.6
  else
    carousel_background_position_x = carousel_background_position_x - 0.6
  end
  carousel_top_banner_ok_string_x = 1000 - small_font:getWidth(_G[configuration.string].mbrUprHudOK)
  carousel_top_banner_back_string_x = carousel_top_banner_ok_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudBck) - 83
  carousel_top_banner_select_string_x = carousel_top_banner_back_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudSel) - 83
  carousel_top_banner_game_list_string_x = carousel_top_banner_select_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudGmLst) - 83
  carousel_top_banner_ok_string_x = ((1280 - (1000 - (carousel_top_banner_game_list_string_x - 46))) / 2) + (1000 - (carousel_top_banner_game_list_string_x - 46)) - (small_font:getWidth(_G[configuration.string].mbrUprHudOK))
  carousel_top_banner_back_string_x = carousel_top_banner_ok_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudBck) - 83
  carousel_top_banner_select_string_x = carousel_top_banner_back_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudSel) - 83
  carousel_top_banner_game_list_string_x = carousel_top_banner_select_string_x - small_font:getWidth(_G[configuration.string].mbrUprHudGmLst) - 83
  if carousel_bubble_caption_timer_set == true then
    carousel_bubble_caption_timer = carousel_bubble_caption_timer + 1
    if carousel_bubble_caption_timer == 1  then
      carousel_bubble_caption_scale_transition = tween_module.new(0.1, carousel_bubble_caption_scale, {factor = 0}, "inExpo")
    elseif carousel_bubble_caption_timer == 17 and carousel_is_in_options == true then
      if carousel_is_leaving_options == false then
        carousel_bubble_caption_x_offset = carousel_option_x_index
        carousel_bubble_caption_scale_transition = tween_module.new(0.2, carousel_bubble_caption_scale, {factor = 1}, "outExpo")
        carousel_bubble_caption_timer = 0
        carousel_bubble_caption_timer_set = false
      end
    end
  end
  if carousel_bubble_caption_x_offset == 0 then
    carousel_bubble_caption_string = _G[configuration.string].mbrUprDsp
  elseif carousel_bubble_caption_x_offset == 1 then
    carousel_bubble_caption_string = _G[configuration.string].mbrUprOpt
  elseif carousel_bubble_caption_x_offset == 2 then
    carousel_bubble_caption_string = _G[configuration.string].mbrUprLng
  elseif carousel_bubble_caption_x_offset == 3 then
    carousel_bubble_caption_string = _G[configuration.string].mbrUprLgl
  elseif carousel_bubble_caption_x_offset == 4 then
    carousel_bubble_caption_string = _G[configuration.string].mbrUprMan
  end
  carousel_on_card_index = (carousel_first_card + carousel_cursor_x_index + 2) % carousel_position_counter
  carousel_thumbnail_cursor_animation:update(dt)

  -- Update suspend point scene variables
  if no_suspend_explanation_timer_set == true then
    if no_suspend_explanation_timer == 120 then
      no_suspend_explanation_transition:update(dt)
    else
      no_suspend_explanation_timer = no_suspend_explanation_timer + 1
    end
  end

  -- Update language scene variables
  language_ok_hud_string_x = 1178 - small_font:getWidth(_G[configuration.string].lngHudOk)
  language_select_hud_string_x = language_ok_hud_string_x - small_font:getWidth(_G[configuration.string].lngHudSel) - 74
  language_ok_string_x = 640 - (medium_font:getWidth(_G[configuration.string].lngOk) / 2)
  language_horizontal_cursor_animation:update(dt)

  -- Update independent variables
  if carousel_background_position_x + carousel_background_tween.x <= -1478  then
    carousel_background_position_x = carousel_background_position_x + 1478
  elseif carousel_background_position_x + carousel_background_tween.x >= 1478 then
    carousel_background_position_x = carousel_background_position_x - 1478
  end
  if carousel_cursor_rectangle_position.y > 217 then
    if carousel_is_in_options == true then
      carousel_is_in_options = false
      carousel_bubble_caption_timer_set = false
      carousel_is_leaving_options = false
    end
  end
  if carousel_background_x_transition then
    carousel_background_x_transition:update(dt)
  end
  if carousel_top_banner_y_transition then
    carousel_top_banner_y_transition:update(dt)
  end
  if carousel_display_icon_scale_transition then
    carousel_display_icon_scale_transition:update(dt)
  end
  if carousel_setting_icon_scale_transition then
    carousel_setting_icon_scale_transition:update(dt)
  end
  if carousel_language_icon_scale_transition then
    carousel_language_icon_scale_transition:update(dt)
  end
  if carousel_legal_icon_scale_transition then
    carousel_legal_icon_scale_transition:update(dt)
  end
  if carousel_manual_icon_scale_transition then
    carousel_manual_icon_scale_transition:update(dt)
  end
  if carousel_x_transition then
    carousel_x_transition:update(dt)
  end
  if carousel_cursor_x_transition then
    carousel_cursor_x_transition:update(dt)
  end
  if carousel_cursor_rectangle_x_transition then
    carousel_cursor_rectangle_x_transition:update(dt)
  end
  if carousel_cursor_rectangle_y_transition then
    carousel_cursor_rectangle_y_transition:update(dt)
  end
  if carousel_cursor_rectangle_width_transition then
    carousel_cursor_rectangle_width_transition:update(dt)
  end
  if carousel_cursor_rectangle_height_transition then
    carousel_cursor_rectangle_height_transition:update(dt)
  end
  if carousel_bubble_caption_scale_transition then
    carousel_bubble_caption_scale_transition:update(dt)
  end
  if no_suspend_background_y_transition then
    no_suspend_background_y_transition:update(dt)
  end
  if no_suspend_cards_y_transition then
    no_suspend_cards_y_transition:update(dt)
  end
  if no_suspend_banner_caption_transition then
    no_suspend_banner_caption_transition:update(dt)
  end
  if mask_card_alpha_transition then
    mask_card_alpha_transition:update(dt)
  end
  if language_scene_out_transition then
    language_scene_out_transition:update(dt)
  end
  if intro_background_sound:isPlaying() == false then
    loop_background_sound:play()
  end

----------------------------------------------------------------------------------------------------------------------

end

function love.draw()

----------------------------------------------------------------------------------------------------------------------

  -- Draw carousel scene graphics
  love.graphics.setColor(1, 1, 1, 1 - mask_card.alpha * 2)
  love.graphics.draw(carousel_background_image, carousel_background_position_x -1478 + carousel_background_tween.x, 96)
  love.graphics.draw(carousel_background_image, carousel_background_position_x + carousel_background_tween.x, 96)
  love.graphics.draw(carousel_background_image, carousel_background_position_x + 1478 + carousel_background_tween.x, 96)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(top_menubar_banner_image, 0, carousel_top_banner_position.y)
  love.graphics.setColor(63/255, 191/255, 1, carousel_top_banner_selection_box_alpha)
  love.graphics.rectangle("fill", 400 + (carousel_option_x_index * 96), 32 + carousel_top_banner_position.y, 96, 70)
  love.graphics.setColor(1, 1, 1, 255)
  love.graphics.draw(display_icon_image, 418 + 63/2, 43 + 51/2 + carousel_top_banner_position.y, math.rad(0), carousel_display_icon_scale.factor, carousel_display_icon_scale.factor, 63/2, 51/2)
  love.graphics.draw(setting_icon_image, 517 + 57/2, 40 + 57/2 + carousel_top_banner_position.y, math.rad(0), carousel_setting_icon_scale.factor, carousel_setting_icon_scale.factor, 57/2, 57/2)
  love.graphics.draw(language_icon_image, 613 + 54/2, 40 + 57/2 + carousel_top_banner_position.y, math.rad(0), carousel_language_icon_scale.factor, carousel_language_icon_scale.factor, 54/2, 57/2)
  love.graphics.draw(legal_icon_image, 712 + 51/2, 40 + 57/2 + carousel_top_banner_position.y, math.rad(0), carousel_legal_icon_scale.factor, carousel_legal_icon_scale.factor, 51/2, 57/2)
  love.graphics.draw(manual_icon_image, 805 + 57/2, 40 + 57/2 + carousel_top_banner_position.y, math.rad(0), carousel_manual_icon_scale.factor, carousel_manual_icon_scale.factor, 57/2, 57/2)
  love.graphics.draw(banner_caption_image, 127, 151 + no_suspend_banner_caption_position.y)
  for i=0, carousel_position_counter - 1, 1 do
    love.graphics.draw(off_card_image, carousel_position.x + carousel_cards_x_position[i], 222 + no_suspend_cards_position.y)
    for j=0, 3, 1 do
      if gamelist[i].suspend_points[j] == "empty" then
        love.graphics.draw(suspend_empty_off_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 22 + (24 * j), 222 + 237  + no_suspend_cards_position.y)
      else
        love.graphics.draw(suspend_active_off_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 22 + (24 * j), 222 + 237  + no_suspend_cards_position.y)
      end
    end
    if i == carousel_on_card_index then
      if gamelist[i].on_alpha < 1 then
        gamelist[i].on_alpha = gamelist[i].on_alpha + 0.08
      end
    else
      if gamelist[i].on_alpha > 0 then
        gamelist[i].on_alpha = gamelist[i].on_alpha - 0.08
      end
    end
    love.graphics.setColor(1, 1, 1, gamelist[i].on_alpha)
    love.graphics.draw(on_card_image, carousel_position.x + carousel_cards_x_position[i], 222 + no_suspend_cards_position.y)
    for j=0, 3, 1 do
      if gamelist[i].suspend_points[j] == "empty" then
        love.graphics.draw(suspend_empty_on_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 22 + (24 * j), 222 + 237 + no_suspend_cards_position.y)
      else
        love.graphics.draw(suspend_active_off_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 22 + (24 * j), 222 + 237 + no_suspend_cards_position.y)
      end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gamelist[i].image, carousel_position.x + carousel_cards_x_position[i] + 12, 222 + 115 + no_suspend_cards_position.y, math.rad(0), 1, 1, 0, gamelist[i].image:getHeight() / 2 )
    if gamelist[i].sram == true then
      love.graphics.draw(sram_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 123, 222 + 225 + no_suspend_cards_position.y)
    end
    if gamelist[i].players == 1 then
      love.graphics.draw(one_player_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 177, 222 + 222 + no_suspend_cards_position.y)
    elseif gamelist[i].players == 2 then
      love.graphics.draw(two_player_card_icon_image, carousel_position.x + carousel_cards_x_position[i] + 174, 222 + 222 + no_suspend_cards_position.y)
    end

    if i ~= carousel_on_card_index then
      love.graphics.setColor(1, 1, 1, mask_card.alpha)
      love.graphics.draw(mask_card_image, carousel_position.x + carousel_cards_x_position[i], 222 + no_suspend_cards_position.y)
      love.graphics.setColor(1, 1, 1, 1)
    end

    carousel_thumbnail_x_position = 640 - ((((carousel_position_counter) * (gamelist[i].image:getWidth() * 0.175 + 1)))/2)
    love.graphics.draw(gamelist[i].image, carousel_thumbnail_x_position + i * (gamelist[i].image:getWidth() * 0.175 + 1), 566, math.rad(0), 0.175, 0.175, 0, gamelist[i].image:getHeight())
  end
  carousel_thumbnail_cursor_animation:draw(thumbnail_cursor_image, carousel_thumbnail_x_position + 4.20 + (carousel_on_card_index * 40.80), 543 - gamelist[carousel_on_card_index].image:getHeight() * 0.175)
  love.graphics.setFont(small_font)
  if carousel_top_banner_selection_box_alpha == 0 then
    love.graphics.draw(up_dpad_icon_image, carousel_menu_string_x - 46, 591)
    love.graphics.print(_G[configuration.string].gmTtlLstHudMen, carousel_menu_string_x, 601)
    love.graphics.draw(down_dpad_icon_image, carousel_suspend_point_string_x - 46, 591)
    love.graphics.print(_G[configuration.string].gmTtlLstHudSus, carousel_suspend_point_string_x, 601)
    love.graphics.draw(select_outline_button_icon_image, carousel_sort_game_string_x - 105, 597)
    love.graphics.print(_G[configuration.string].gmTtlLstHudSrt, carousel_sort_game_string_x, 601)
    love.graphics.draw(start_outline_button_icon_image, carousel_start_game_string_x - 90, 597)
    love.graphics.print(_G[configuration.string].gmTtlLstHudSta, carousel_start_game_string_x, 601)
  else
    love.graphics.draw(down_dpad_icon_image, carousel_top_banner_game_list_string_x - 46, 591)
    love.graphics.print(_G[configuration.string].mbrUprHudGmLst, carousel_top_banner_game_list_string_x, 601)
    love.graphics.draw(horizontal_dpad_icon_image, carousel_top_banner_select_string_x - 46, 591)
    love.graphics.print(_G[configuration.string].mbrUprHudSel, carousel_top_banner_select_string_x, 601)
    love.graphics.draw(b_outline_button_icon_image, carousel_top_banner_back_string_x - 46, 590)
    love.graphics.print(_G[configuration.string].mbrUprHudBck, carousel_top_banner_back_string_x, 601)
    love.graphics.draw(a_outline_button_icon_image, carousel_top_banner_ok_string_x - 46, 590)
    love.graphics.print(_G[configuration.string].mbrUprHudOK, carousel_top_banner_ok_string_x, 601)
  end
  love.graphics.draw(bottom_menubar_banner_image, 0, 630)
  love.graphics.setColor(0.16, 1, 1, 255)
  if carousel_is_in_options == true then
    love.graphics.draw(square_frame_cursor_image, carousel_cursor_rectangle_position.x, carousel_cursor_rectangle_position.y)
    love.graphics.rectangle("fill", carousel_cursor_rectangle_position.x + 23, carousel_cursor_rectangle_position.y, carousel_cursor_rectangle_position.width - 34.5, 6)
    love.graphics.draw(square_frame_cursor_image, carousel_cursor_rectangle_position.x + carousel_cursor_rectangle_position.width - 11.5, carousel_cursor_rectangle_position.y + 11.5, math.rad(90), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_rectangle_position.x + carousel_cursor_rectangle_position.width - 6, carousel_cursor_rectangle_position.y + 23, 6, carousel_cursor_rectangle_position.height - 34.5)
    love.graphics.draw(square_frame_cursor_image, carousel_cursor_rectangle_position.x + carousel_cursor_rectangle_position.width - 11.5, carousel_cursor_rectangle_position.y + carousel_cursor_rectangle_position.height - 11.5, math.rad(180), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_rectangle_position.x + 23, carousel_cursor_rectangle_position.y + carousel_cursor_rectangle_position.height - 6, carousel_cursor_rectangle_position.width - 46, 6)
    love.graphics.draw(square_frame_cursor_image, carousel_cursor_rectangle_position.x + 11.5, carousel_cursor_rectangle_position.y + carousel_cursor_rectangle_position.height - 11.5, math.rad(270), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_rectangle_position.x, carousel_cursor_rectangle_position.y + 23, 6, carousel_cursor_rectangle_position.height - 34.5)
  else
    love.graphics.draw(round_frame_cursor_image, carousel_cursor_position.x, 219  + no_suspend_cards_position.y)
    love.graphics.rectangle("fill", carousel_cursor_position.x + 23, 219 + no_suspend_cards_position.y, 212, 6)
    love.graphics.draw(round_frame_cursor_image, carousel_cursor_position.x + 235 + 11.5, 219 + 11.5 + no_suspend_cards_position.y, math.rad(90), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_position.x + 252, 242 + no_suspend_cards_position.y, 6, 236)
    love.graphics.draw(round_frame_cursor_image, carousel_cursor_position.x + 235 + 11.5, 478 + 11.5 + no_suspend_cards_position.y, math.rad(180), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_position.x + 23, 495 + no_suspend_cards_position.y, 212, 6)
    love.graphics.draw(round_frame_cursor_image, carousel_cursor_position.x + 11.5, 478 + 11.5 + no_suspend_cards_position.y, math.rad(270), 1, 1, 11.5, 11.5)
    love.graphics.rectangle("fill", carousel_cursor_position.x, 242 + no_suspend_cards_position.y, 6, 236)
  end
  love.graphics.setColor(1, 1, 1, 1)
  if carousel_bubble_caption_scale.factor < 0.5 then
    love.graphics.setColor(1, 1, 1, 0)
  end
  if carousel_bubble_caption_x_offset ~= 3 then
    love.graphics.draw(normal_bubble_caption_image, 450 + (carousel_bubble_caption_x_offset * 96), 95 + carousel_top_banner_position.y, math.rad(0), carousel_bubble_caption_scale.factor, carousel_bubble_caption_scale.factor, 86, 0)
  else
    love.graphics.draw(long_bubble_caption_image, 450 + (carousel_bubble_caption_x_offset * 96), 95 + carousel_top_banner_position.y, math.rad(0), carousel_bubble_caption_scale.factor, carousel_bubble_caption_scale.factor, 86+27, 0)
  end
  love.graphics.setFont(small_font)
  love.graphics.print(carousel_bubble_caption_string, 450 + (carousel_bubble_caption_x_offset * 96), 96 + carousel_top_banner_position.y, math.rad(0), carousel_bubble_caption_scale.factor, carousel_bubble_caption_scale.factor, small_font:getWidth(carousel_bubble_caption_string) / 2 + 1, -30)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.setFont(large_font)
  love.graphics.print(gamelist[carousel_on_card_index].title, 640, 163 + no_suspend_banner_caption_position.y, math.rad(0), 1, 1, large_font:getWidth(gamelist[carousel_on_card_index].title) / 2)
  love.graphics.setColor(1, 1, 1, 1)

  -- Draw suspend point scene graphics
  love.graphics.draw(bottom_suspend_banner_image, 0, no_suspend_background_position.y)
  love.graphics.draw(tail_suspend_banner_image, 222 + (262 * carousel_cursor_x_index), no_suspend_background_position.y - tail_suspend_banner_image:getHeight() + 9)
  love.graphics.setColor(190/255, 0, 26/255, 1)
  love.graphics.print(_G[configuration.string].susTtl, 609 + 61, no_suspend_background_position.y + 15, 0, 1, 1, large_font:getWidth(_G[configuration.string].susTtl)/2, 0)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(suspend_icon_image, 609 - large_font:getWidth(_G[configuration.string].susTtl)/2, no_suspend_background_position.y + 6)
  love.graphics.draw(first_slot_icon_image, 106, no_suspend_background_position.y + 86)
  love.graphics.draw(suspend_slot_image, 151, no_suspend_background_position.y + 86)
  love.graphics.draw(second_slot_icon_image, 106 + 260, no_suspend_background_position.y + 86)
  love.graphics.draw(suspend_slot_image, 151 + 260, no_suspend_background_position.y + 86)
  love.graphics.draw(third_slot_icon_image, 106 + 260 + 260, no_suspend_background_position.y + 86)
  love.graphics.draw(suspend_slot_image, 151 + 260 + 260, no_suspend_background_position.y + 86)
  love.graphics.draw(fourth_slot_icon_image, 106 + 260 + 260 + 260, no_suspend_background_position.y + 86)
  love.graphics.draw(suspend_slot_image, 151 + 260 + 260 + 260, no_suspend_background_position.y + 86)
  love.graphics.setFont(medium_font)
  love.graphics.setColor(86/255, 84/255, 100/255, 1)
  love.graphics.print(_G[configuration.string].susNoDat, 151 + (suspend_slot_image:getWidth() / 2), no_suspend_background_position.y + 158, 0, 1, 1, medium_font:getWidth(_G[configuration.string].susNoDat)/2, 0)
  love.graphics.print(_G[configuration.string].susNoDat, 151 + 260 + (suspend_slot_image:getWidth() / 2), no_suspend_background_position.y + 158, 0, 1, 1, medium_font:getWidth(_G[configuration.string].susNoDat)/2, 0)
  love.graphics.print(_G[configuration.string].susNoDat, 151 + 260 + 260 + (suspend_slot_image:getWidth() / 2), no_suspend_background_position.y + 158, 0, 1, 1, medium_font:getWidth(_G[configuration.string].susNoDat)/2, 0)
  love.graphics.print(_G[configuration.string].susNoDat, 151 + 260 + 260 + 260 + (suspend_slot_image:getWidth() / 2), no_suspend_background_position.y + 158, 0, 1, 1, medium_font:getWidth(_G[configuration.string].susNoDat)/2, 0)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(small_font)
  love.graphics.print(_G[configuration.string].susHudBck, 609 + 36 + 13, no_suspend_background_position.y + 290, 0, 1, 1, small_font:getWidth(_G[configuration.string].susHudBck) / 2, 0)
  love.graphics.draw(b_normal_button_icon_image, 609 + 13 - small_font:getWidth(_G[configuration.string].susHudBck)/2, no_suspend_background_position.y + 285)
  love.graphics.setFont(medium_font)
  love.graphics.setColor(1, 1, 1, no_suspend_explanation.alpha)
  love.graphics.draw(explanation_caption_image, 640, no_suspend_background_position.y + 205, 0, 1, 1, (explanation_caption_image:getWidth() / 2), 0)
  love.graphics.print(_G[configuration.string].susExp, 640, no_suspend_background_position.y + 233, 0, 1, 1, medium_font:getWidth(_G[configuration.string].susExp)/2, 0)
  love.graphics.setColor(1, 1, 1, 1)

  -- Draw language scene graphics
  love.graphics.draw(option_background_image, 0, 0 + language_scene_position.y)
  love.graphics.draw(language_icon_image, 101, 48 + language_scene_position.y)
  love.graphics.setFont(large_font)
  love.graphics.print(_G[configuration.string].lngTtl, 168, 59 + language_scene_position.y)
  love.graphics.setFont(small_font)
  love.graphics.draw(normal_dpad_icon_image, language_select_hud_string_x - 39, 56 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngHudSel, language_select_hud_string_x, 66 + language_scene_position.y)
  love.graphics.draw(a_outline_button_icon_image, language_ok_hud_string_x - 39, 56 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngHudOk, language_ok_hud_string_x, 66 + language_scene_position.y)
  love.graphics.setColor(1, 1, 1, 1 - language_on_dialog_button_alpha)
  language_horizontal_cursor_animation:draw(horizontal_cursor_image, 136 + language_selection_box_x_offset * 528, 168 + language_selection_box_y_offset * 96 + language_scene_position.y)
  love.graphics.setColor(0, 0.45, 0.93, 1 - language_on_dialog_button_alpha)
  love.graphics.rectangle('fill', language_selection_box_x_offset * 528 + 185, language_selection_box_y_offset * 96 + 144  + language_scene_position.y, 432, 72)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(off_radio_button_image, 202, 162 + language_scene_position.y)
  love.graphics.setFont(medium_font)
  love.graphics.print(_G[configuration.string].lngEn, 275, 169 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 202, 258 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngFr, 275, 265 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 202, 354 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngDe, 275, 361 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 202, 450 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngEs, 275, 457 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 730, 162 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngIt, 803, 169 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 730, 258 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngNl, 803, 265 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 730, 354 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngPt, 803, 361 + language_scene_position.y)
  love.graphics.draw(off_radio_button_image, 730, 450 + language_scene_position.y)
  love.graphics.print(_G[configuration.string].lngRu, 803, 457 + language_scene_position.y)
  love.graphics.draw(on_radio_button_image, language_on_radio_button_x_position, language_on_radio_button_y_position + language_scene_position.y)
  love.graphics.draw(off_dialog_button_image, 520, 572 + language_scene_position.y)
  love.graphics.setColor(1, 1, 1, language_on_dialog_button_alpha)
  love.graphics.draw(on_dialog_button_image, 508, 560 + language_scene_position.y)
  love.graphics.setColor(language_on_dialog_button_alpha, language_on_dialog_button_alpha, language_on_dialog_button_alpha, 1)
  love.graphics.print(_G[configuration.string].lngOk, language_ok_string_x, 586 + language_scene_position.y)
  love.graphics.setColor(1, 1, 1, 1)
----------------------------------------------------------------------------------------------------------------------

end
