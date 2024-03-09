GalaxyblitzClient is the source code of Galaxyblitz. The game development engine is Unity 3D, and the engine version used is Unity 2019.4.21f1 (64-bit).
The game fighting logic is written in C#, and the functional logic is written in Lua. The game communication protocol uses Google Protobuf.  

The Assets directory corresponds to the Assets directory of the Unity project. Keep this directory structure and put it in your Unity project.  
Assets catalog description:  
Assets/GameRes is a storage directory for art source files, including original game paintings, UI, architectural models, hero models, actions, special effects, etc.  
Assets/Prefabs is a storage directory for game project prefabs, including building prefabs, soldier prefabs, UI prefabs, etc.  
Assets/Scenes is a storage directory for game scenes, including landing scenes, main base scenes, battle scenes, etc.  
Assets/Scripts/Common is the basic library of the project.  
Assets/Scripts/Client is the project's basic network library, and the network connection uses TCP protocol.  
Assets/Source/battle is the core code of the project battle, and the game battle uses lockstepsync technology.  
Assets/Source/battle/NewBattle/AStart/ is the core of the project AI pathfinding algorithm, using the A* algorithm.  
Assets/Lua is a logic module of game functions, which can be hot updated.  
Assets/Lua/UI is the UI manager module, including the login interface, main interface, construction interface, etc.  
Assets/Lua/data is the game data management module, including battleship data, hero data, building data, etc.  
Assets/Shader is the storage directory of the project Shader.  

Statement:  
This project is a closed source project and does not provide deployment tutorials. The usage of this project's codes for other purposes will lead to legal responsibilities.
