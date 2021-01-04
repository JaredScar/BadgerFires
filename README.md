# BadgerFires

## Jared's Developer Community [Discord]
[![Developer Discord](https://discordapp.com/api/guilds/597445834153525298/widget.png?style=banner4)](https://discord.com/invite/WjB5VFz)

## What is it?
I always see people asking for Fire scripts. The ones people usually use have tons of bugs and/or are broken, so I decided to create one that actually worked well with a lot of nice features to it. Hopefully you all can find some use out of it.
## All I ask
I make plenty of resources for these forums free of charge all for everyone's convenience. As a recently graduated college student I will be looking for a job soon, so having a following on GitHub really looks good to recruiters. In return for my efforts that benefit this community, I hope you all can pay it forward by giving me a follow on my GitHub, that's all. Thanks.

## Commands
`/fire start <inFrontDistance> <size> <density> <flameScale>` - Starts a fire

`/fire preview <inFrontDistance> <size> <density> <flameScale>` - Previews a fire's size

`/fire stop <ID>` - Stops a fire based off it's ID

`/fire stopall` - Requires the BadgerFires.StopAll permission node

`/fires` - Lists all your started fires with their fire IDs

## Images
### Command Usage Example
https://i.gyazo.com/8297820b15937c753709a109a86d0e14.png

### Fire Preview
https://i.gyazo.com/e7826bee53a74c66bcf97fc7963a9527.gif
### Fire Start
https://i.gyazo.com/e0ca13b53a6525f3404db8bcb34efbc5.gif

### The /fires command
https://i.gyazo.com/3be355df2693d271d02c0a501f49b6ac.png

### Turning off preview mode
https://i.gyazo.com/07f09c8c909c85b401a5af90325fc9a6.gif

### Stopping the fire
https://i.gyazo.com/563d3727f86a8434ea5d6ce5f323fc8a.gif

## Configuration
```lua
Config = {
    MaxSize = 5,
    MaxDensity = 5,
    MaxFlameScale = 5,
    Concurrent = 1,
    AnyoneCanUse = true, -- Anyone can use it? -- THIS WILL DISABLE PERMISSIONS
}


-- ONLY ACTIVE IF `AnyoneCanUse` is set to false
Config.Permissions = { -- ACE PERMISSIONS
    ['BadgerFires.Start.15'] = {
        MaxSize = 15,
        MaxDensity = 15,
        MaxFlameScale = 15,
        Concurrent = 3,
    },
    ['BadgerFires.Start.30'] = {
        MaxSize = 30,
        MaxDensity = 30,
        MaxFlameScale = 30,
        Concurrent = 5,
    },
}
```
This should be pretty self explanatory...
## Credits

### Lucas Decker (lucas.d.200501@gmail.com)

### Dylan Thuillier (itokoyamato@hotmail.fr)

Thank you to these 2 individuals for the base code I based this resource off of. Despite it not being very well-documented, the code was well-written and I made it up to date with FiveM standards.
## Download
https://github.com/JaredScar/BadgerFires
