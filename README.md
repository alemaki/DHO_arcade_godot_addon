---
title: "DHO Arcade Godot Addon"
author: "Alexander Makedonski"
---
### Description
This is a godot plugin that gives access to predefined input actions for [DevHubOne](https://www.devhubone.com/en)'s joypad, scenes used in DevHubOne's arcade and API classes for anyone who needs a deeper integration with the joypad in their game.

### Table of Contents
- [Installation](#installation)
- [Getting started](#getting-started)
- [Credits](#credits)


### Installation
Go to ...[TODO] the godot asset library and download there or download this plugin manually from the github and place the addon folder directly in your project. After that go to <code> Project -> Project Settings -> Plugins </code> and enable this plugin. Restart the editor so any changes to the project can load properly.

### How to Use the Project
#### Getting started
After downloading the plugin and enabling it you can take a look at the newly defined input actions in your project in <code>Project -> Project Settings -> Input Map</code>. There are also a few autoloads that will work in the background one of which you can access in your code.


#### Input capture
The actions are added when enabling the plugin. Some of them are godot's built in actions. They mapped to DevHubOne's joypad like this:

- Buttons:
    - the A button      : "ui_accept"
    - the B button      : "ui_back"
    - the C button      : "ui_c"
    - the D button      : "ui_d"
    - the E button      : "ui_e"
    - the F button      : "ui_f"
    - the Play (Left) button        : "ui_play"
    - the Exit (Right) button       : "ui_menu"
- Joystick:
    - left	: "ui_left"
    - right	: "ui_right"
    - up	: "ui_up"
    - down	: "ui_down"

To get input information just capture the action mappings:
<codeblock>
var axis_X: float = Input.get_axis("ui_left", "ui_right")
var axis_Y: float = Input.get_axis("ui_up", "ui_down")
</codeblock>

Feel free to get the direct input with:
<codeblock>
var input_left: float = Input.get_action_strength("ui_left") # for example
</codeblock>

WARNING: DO NOT USE <code>Input.get_vector</code> like this:
<codeblock>
var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
</codeblock>
As of currently (6th November 2026), in godot 4.x, joypad inputs will result with some error along the axis that is not pressed when calling the Input.get_vector with combination of keyboard input.
Issue to resolve: https://github.com/godotengine/godot/issues/90515#issuecomment-2616602880

I recommend using these defaults since they are better integrated in the engine and even have interactions with the UI.
##### Creating your own input actions
##### TODO: maybe split this into different documentation and tell the user to read the dhojoypad script where all of this is said.
If you want to define your own actions, read below:

WARNING:
Deleting those actions will require you to reload the plugin to have them again. Otherwise you can create your own input actions and map them yourself. You are not required to use the ones provided in the plugin. The test scene for the joypad works with the raw input and won't break if the defaults ahve been removed. However the asset scenes provided in this plugin work with input actions, so you will have to edit them and include your own actions.

You can also create your own actions with mappings for DHO's buttons with their respective input event names:

- Buttons:
    - A		: Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices
    - B		: Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices
    - C		: Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices
    - D		: Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices
    - E		: Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)
    - F		: Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)
    - PLAY	: Joypad Button 6 (Start, Xbox Menu, Nintendo +)
    - EXIT	: Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)
- Joystick:
    - left	: Joypad Axis 0 - (Left stick Left, Joystick 0 Left)
    - right	: Joypad Axis 0 + (Left stick Right, Joystick 0 Right)
    - up	: Joypad Axis 1 - (Left stick Up, Joystick 0 Up)
    - down	: Joypad Axis 1 + (Left stick Down, Joystick 0 Down)

Optionaly you can capture input from the autoloaded DhoJoypad signal's like:
<codeblock>
DhoJoypad.dho_button_released.connect(\<your function(button, device)>)
DhoJoypad.dho_button_released.connect(\<your function(button, device)>)
</codeblock>
There is also a small API which can also by accessed like :
<codeblock>
DhoJoypad.is_button_pressed(\<button>, \<device number>)
DhoJoypad.get_button_hold_duration_sec(\<button>, \<device number>)
</codeblock>
For movement:
<codeblock>
DhoJoypad.get_input_vector() 
DhoJoypad.get_normalized_input_vector()
</codeblock>

WARNING: Disabling the autoload of this node (or disabling the plugin) will BREAK the joypad test scene provided by this plugin.

# If you wish to create a game that works both with keyboard and the DHO's joypad you can map your
# keyboard variants to those actions.

##### Multiple devices (e.g. 2 or more joypads)
Any mention of any the input actions above is a descripton for all devices actions. Each input action has it's mirror for a single device with the same name with appended "_device_[num]" (devices are 0-counted) string at the end. For example: "ui_accept" is the the action that all devices activate when pressing the A button. "ui_accept_device_0" is the input action for device 0 (the first deivce) and device 1 (the second device) has an action "ui_accept_device_1" mapped to it. "ui_left" is for all devices, "ui_left_device_0" for the first device and "ui_left_device_1" for teh second device, etc.

If you want to create a game with single player, by all means use the general actions. However, If you wish to create a game that uses multiple DevHubOne's joypads you might have to use the more targeted actions.

### Credits
#TODO

### License
#TODO