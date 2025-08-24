script:Destroy()

--[[

Before getting started, read this whole article for a REALLY good starting point with pathfinding in Roblox!
https://create.roblox.com/docs/characters/pathfinding


[Overview]

SimpleTRACK is a script that tracks the closest player.
It DOES NOT, account for line of sight, though you can use the Forbidden math library to add it very easily
in the `IsTargetValid` hook.


[Files]
    # SimpleTRACK Full
        > The main script, to be placed in the NPC (more info on setup below) 

    # Hooks
        > Used for connecting to the script externally, and interacting with various components.

    # Config
        > Contains key settings

    # PathfindingLinks
        > Used to integrate pathfinding links.


[Support]

If you need help, you can join the discord here:
    > https://discord.com/invite/7vTTmRC2Zm

Please keep in mind, I really want to help you!
However, it is unrealistic to assist absolutely everyone.


[Developers Comments]
/!\
    I really encourage you to create your own NPC scripts,
    SimpleTRACK is just an example to showcase the proper way to develop these scripts.
/!\


[Setup]
    >   Place Forbidden in ReplicatedStorage
    >   Place the script in the NPC
    >   Tweak the config
    >   Done!


[Proper Usage]
    >   Everytime you alter the map, check for pathfinding inconsistencies
    >   Add a pathfinding modifier with `PassThrough` to everything you do not want to interfere with the AI
    >   Understand, Forbidden has nothing to do with how the pathfind is computed. (except for DirectMoveTo)
            If it gets stuck, yes, Roblox's pathfinding is horrible. But it is most likely poor map design!
            Please ask around for proper ways to develop around pathfinding NPCs!
    >   If your NPC is having too much trouble with an area, use a Pathfinding Link.
        >   Parkour
        >   Climbing
        >   Stairs
        >   Doors


Good luck creating your game, @CritDEV.
]]--