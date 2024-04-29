# Evolution Simulator


## About 

This is a program where you can design and run your own simulation of evolution. There are two types organism available to you: plants and creatures. They each have their own DNA and ways it which they exist in the world. 


## Running the project

This folder is a Godot project and should be treated as such. You can download the editor here: https://godotengine.org/ version 4.2 and import this as a project.
The main scene is the MainMenu.tscn scene, and is what the project was designed to be run from. The main.tscn can also be run separately, but it has some modified behavior form the default settings. 

Exporting the project increases the performance by a lot, so it's recommended for running bigger simulations. How to do that can be found here: https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html


**If you get error that the MainScene is corrupted do Project -> Reload Current Project and it should work". Not sure why this is happening but reloading always helps for me. 


## Controls 

You can move around the map using **WSAD**. The **mouse wheel** is used for zooming in and out. You can use the **+** and **-** keys to adjust the speed of the simulation, thou do be aware the high speeds can lead to the physics not working properly. 

By pressing the Creature / Plant button and selecting the random option, you can now place organisms in to the world using your left mouse key. 

By pressing the Paint button and selecting terrain type you can paint and remove tiles form the map using your left and right keys respectively. 

When you click on a creature or a plant a info card about them will appear showing you some additional information about that organism. On the sensors information you can hover above the different sensors to get more information about them. You should be in the select mode for this so that you don't also perform any other action when selecting creatures, to enter select mode just press the select button. 


## Save Files and Data Collection 

You simulations will be saved in the default folder for program data on your operating system. Data collected using data collection also go in this folder. 

Windows: `%APPDATA%\Godot\app_userdata\[project_name]` 

macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]` 

Linux: `~/.local/share/godot/app_userdata/[project_name]` 


More info: https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#doc-data-paths
