---
title: "DHO Arcade Godot Addon"
author: "Alexander Makedonski"
---
### Description
This is a godot plugin that gives access to predefined input actions for [DevHubOne](https://www.devhubone.com/en)'s joypad, scenes used in DevHubOne's arcade and API classes for anyone who needs a deeper integration with the joypad in their game.

### Table of Contents
- [Installation](#installation)
- [Getting started](#getting-started)
- [Joypad API](#joypad-api)
- [Scenes and passing information between scenes](#scenes-and-passing-information-between-scenes)
- [Score saving](#score-saving)
- [Localization](#localization)
- [Credits](#credits)


### Installation
Go to ...[TODO] the godot asset library and download there or download this plugin manually from the github and place the addon folder directly in your project. After that go to <code> Project -> Project Settings -> Plugins </code> and enable this plugin. Restart the editor so any changes to the project can load properly.

### How to Use the Project
#### Getting started
After downloading the plugin and enabling it you can take a look at the newly defined input actions in your project in <code>Project -> Project Settings -> Input Map</code>. There are also a few autoloads that will work in the background one of which you can access in your code.


#### Input capture
The actions are added when enabling the plugin. Some of them are godot's built in actions. They mapped to DevHubOne's joypad like this:

| DHO button | Action name |                            Joypad button event name                            |
|------------|-------------|--------------------------------------------------------------------------------|
| A          | "ui_accept" | Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices  |
| B          | "ui_back"   | Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices  |
| C          | "ui_c"      | Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices  |
| D          | "ui_d"      | Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices   |
| E          | "ui_e"      | Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)                              |
| F          | "ui_f"      | Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)                            |
| PLAY       | "ui_play"   | Joypad Button 6 (Start, Xbox Menu, Nintendo +)                                 |
| EXIT       | "ui_menu"   | Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)                     |

| Joystick | Action name |                Joypad button event name             |
|----------|-------------|-----------------------------------------------------|
| left     | "ui_left"   | Joypad Axis 0 - (Left stick Left, Joystick 0 Left)  |
| right    | "ui_right"  | Joypad Axis 0 + (Left stick Right, Joystick 0 Right)|
| up       | "ui_up"     | Joypad Axis 1 - (Left stick Up, Joystick 0 Up)      |
| down     | "ui_down"   | Joypad Axis 1 + (Left stick Down, Joystick 0 Down)  |

To get input information just capture the action mappings:
```
var axis_X: float = Input.get_axis("ui_left", "ui_right")
var axis_Y: float = Input.get_axis("ui_up", "ui_down")
```

Feel free to get the direct input with:
```
var input_left: float = Input.get_action_strength("ui_left") # for example
```

##### If you wish to create a game that works both with keyboard and the DHO's joypad you can map your keyboard variants to those actions.

WARNING: DO NOT USE `Input.get_vector` like this:
```
var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
```
As of currently (6th November 2026), in godot 4.x, joypad inputs will result with some error along the axis that is not pressed when calling the Input.get_vector with combination of keyboard input.
Issue to resolve: https://github.com/godotengine/godot/issues/90515#issuecomment-2616602880

I recommend using these defaults since they are better integrated in the engine and even have interactions with the UI.
#### Creating your own input actions
If you want to define your own actions, read below:

WARNING:
Deleting those actions will require you to reload the plugin to have them again. Otherwise you can create your own input actions and map them yourself. You are not required to use the ones provided in the plugin. The test scene for the joypad works with the raw input and won't break if the defaults have been removed. However the asset scenes provided in this plugin work with input actions, so you will have to edit them and include your own actions.

You can also create your own actions with mappings for DHO's buttons with their respective input event names given in the table above.

##### Multiple devices (e.g. 2 or more joypads)
Any mention of any the input actions above is a description for all devices actions. Each input action has its mirror for a single device with the same name with appended "_device_[num]" (devices are 0-counted) string at the end. For example: "ui_accept" is the the action that all devices activate when pressing the A button. "ui_accept_device_0" is the input action for device 0 (the first device) and device 1 (the second device) has an action "ui_accept_device_1" mapped to it. "ui_left" is for all devices, "ui_left_device_0" for the first device and "ui_left_device_1" for the second device, etc.

If you want to create a game with single player, by all means use the general actions. However, If you wish to create a game that uses multiple DevHubOne's joypads you might have to use the more targeted actions, the Joypad API or define your own.

Just in case you plan on making a game with more than 2 joypads connected :
- Increase `MAX_DEVICES_HANDLED` as you like and reload the plugin. It will create new actions for you and map the joypads. `DHOJoypad` class requires it too, for the API to work.

### Joypad API
Skip this section if you are planning on using only the predefined input actions stated above!

`DhoJoypad` is the autoloaded node of this plugin.

You can capture input from DhoJoypad signals like:
```GDScript
DhoJoypad.dho_button_pressed.connect(<your function(button, device)>)
DhoJoypad.dho_button_released.connect(<your function(button, device)>)
```GDScript
There is also a small API which can also be accessed like :
```
DhoJoypad.is_button_pressed(<button>, <device number>)
DhoJoypad.get_button_hold_duration_sec(<button>, <device number>)
```
For movement:
```GDScript
DhoJoypad.dho_joystick_changed.connect(<your function(device)>) # emits normalized input
DhoJoypad.get_input_vector() 
DhoJoypad.get_normalized_input_vector()
```

WARNING: Disabling the autoload of this node (or disabling the plugin) will BREAK the joypad test scene provided by this plugin.

### Scenes and passing information between scenes
#### DHOScene
Every scene root in your game must inherit from this node (or be it) for you to use DHOSceneManager to change scenes with passing the contex around in your game. If you do not want to pass context in your scenes, you can jsut pass a new context whenever you switch to one of the plugin's scene and ignore this class.

#### DHOSceneContext
A resource for managing information between scenes. Use this in your scenes paired with `DHOScene` to pass the game information around scenes. You will have to pass this to the plugin's scenes so they will work properly.

The data fields below are required for the plugin's scenes. You can edit these in your own scenes to keep track of information then pass it to other DHO scenes from the plugin. They will take care of the information for you.

| Field | Description |
|-------|-------------|
| `score` | How much score did the player get. Keep value between 0 and 999999. |
| `is_win` | Before changing the scene set this to `true` if player won. Otherwise set to `false`. |

Add other information for your scenes as you see fit. Or even better: extend this class.

#### DHOSceneManager
A static class that contains method for changing scenes for DevHubOne's arcade.

`change_scene(current_node, to_path, context)`: Changes the current scene to the next and passes the context to that scene.
- `current_node` : any node from the current scene will do.
- `to_path` : scene path to change to. The resulting scene MUST inherit `DHOScene`
- `context`: The context to pass to the next scene.

`change_scene_new_context(current_node, to_path, score = 0)`: Changes the current scene to the next creates new context for that scene.
- `current_node` : any node from the current scene will do.
- `to_path` : scene path to change to. The resulting scene MUST inherit `DHOScene`
- `score` : Optional. Set the score in a new scene. Otherwise will be set to 0.

#### How to swotch to score saving / win / lose scenes
##### 1. You can use `DHOSceneManager` directly
This is a static class that contains method for changing scenes for DevHubOne's arcade.

`change_scene(current_node, to_path, context)`: Changes the current scene to the next and passes the context to that scene. Use this to switch if you have a current context.
- `current_node` : any node from the current scene will do.
- `to_path` : scene path to change to. The resulting scene MUST inherit `DHOScene`
- `context`: The context to pass to the next scene.

`change_scene_new_context(current_node, to_path, score = 0)`: Changes the current scene to the next creates new context for that scene. Use this for restarts of the game.
- `current_node` : any node from the current scene will do.
- `to_path` : scene path to change to. The resulting scene MUST inherit `DHOScene`
- `score` : Optional. Set the score in a new scene. Otherwise will be set to 0.

##### 2. You can use `DHOWinLoseEvent`
You can use this node to switch to a different `DHOScene`. Normally when the game ends you should switch to the save_score.tscn. You can do whatever you want, tho. Set `is_win` before switching to save_score or win_lose scene to know if the player won or lost. Other info will be handled.

NOTE: This node requires a current `DHOScene`. If not set it will search for it.

Call `execute()` when ready to change scene.


#### Scenes provided by the plugin

`dho_exit_trigger.tscn` - Autoloaded by the plugin. It's an UI Node that stays hidden until the exit button is pressed. If the exit button is pressed twice, this scene will trigger an exit of the game. WARNING: It is required for DevHubOne's arcade! 
`dho_joypad_test.tscn` - TODO:
`dho_save_score.tscn` - TODO:
`dho_win_lose.tscn` - TODO: 
`dho_scoreboard.tscn` - TODO: 

### Score saving
The dho_save_score.tscn handles the score saving for you. All you need is at the end of the game to pass the dho_context with value for the score and is_win set. Everything will be handled from there. If the score is not a new record (top 10 scores) the scene will skip saving and go directly to win / lose scene.

### Localization
These classes are a part of the plugin's scenes. You can make use of them, however I would recommend against it in a game jam setting, because you won't need localization.
- `DHOLocalizedText`: This class stores localized keys and writes them in the given format.
- `DHOLocalizedLabel`: This class sets a label with localized text.
- `DHOBlinkingLabel`: This class sets a label with localized text and then blinks.
- `DHOScoreLabel`: You can use this score label in your games. See how in the score_saver or win_lose scene.


### Credits
#TODO

### License
#TODO
