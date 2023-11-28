Config = {
    ParticleEffect = "ent_ray_ch2_farm_fire_dble",
    MaxSize = 500,
    MaxDensity = 500,
    MaxFlameScale = 500,
    Concurrent = 1,
    AnyoneCanUse = true, -- Anyone can use it? -- THIS WILL DISABLE PERMISSIONS

    --[[ BELOW CONFIG OPTIONS ARE IN PROGRESS (IN DEVELOPMENT) ]]--
    RandomFireSpawning = true, -- Fires spawn randomly?
    RandomFireSpawningDelay = 1, -- After a fire randomly spawns, 1 minutes must pass before another one can be spawned
    RandomFireChance = 90, -- 90% chance of a fire starting
    RandomFireLocations = {
        { name = 'Wearhouse @ 35', x = 53.84, y = -2675.58, z = 6.01, size = 30, density = 30, flameScale = 30 },
        { name = 'Clothing Store @ 134', x = 76.97, y = -1392.78, z = 29.38, size = 30, density = 30, flameScale = 30 },
        { name = 'DMV @ 140', x = 208.13, y = -1391.37, z = 30.58, size = 30, density = 30, flameScale = 30 },
        { name = 'Ammunation @ 200', x = 11.72, y = -1107.4, z = 29.8, size = 30, density = 30, flameScale = 30 },
        { name = 'Repo Yard @ 394', x = -190.69, y = -1164.15, z = 23.67, size = 30, density = 30, flameScale = 30 },
        { name = 'Auto Garage @ 90', x = -1154.43, y = -2007.64, z = 13.18, size = 30, density = 30, flameScale = 30 },
        { name = 'Open Garage @ 388', x = -422.48, y = -1683.1, z = 19.03, size = 30, density = 30, flameScale = 30 },
        { name = 'Tattoo Vinewood @ 575', x = 323.85, y = 181.41, z = 103.59, size = 30, density = 30, flameScale = 30 },
        { name = 'Bay City Bank @ 323', x = -1308.58, y = -826.66, z = 17.15, size = 30, density = 30, flameScale = 30 },
        { name = 'House being built @ 334', x = -1125.81, y = -960.89, z = 6.63, size = 30, density = 30, flameScale = 30 },
        { name = 'Cafe @ 307', x = -1218.0, y = -1493.48, z = 4.37, size = 30, density = 30, flameScale = 30 },
        { name = 'Booth on the pier @ 611', x = -1605.87, y = -1074.14, z = 13.02, size = 30, density = 30, flameScale = 30 },
        { name = 'Church @ 631', x = -1680.76, y = -282.07, z = 51.86, size = 30, density = 30, flameScale = 30 },
    },
    RandomFiresAllowedNearPlayers = true, -- If a random fire spawns, should it still trigger if players are within it?
    VehicleEngineFires = true -- Needs to be implemented...
    --[[]]--
}

Config.Messages = {
    Error = {
        ConcurrentFiresReached = '^1[^5BadgerFires^1] ^1ERROR: You have enough fires active. You are only allowed to have ^3{MAX_CONCURRENT}',
        InvalidParams = '^1[^5BadgerFires^1] ^1ERROR: You provided an invalid parameter type... They should all be numbers!',
        SizeTooBig = '^1[^5BadgerFires^1] ^1ERROR: You provided to big of a ^5size^1... You are only allowed sizes up to ^3{MAX_SIZE}',
        DensityTooBig = '^1[^5BadgerFires^1] ^1ERROR: You provided to big of a ^5density^1... You are only allowed densities up to ^3{MAX_DENSITY}',
        FlameScaleTooBig = '^1[^5BadgerFires^1] ^1ERROR: You provided to big of a ^5flameScale^1... You are only allowed flameScales up to ^3{MAX_FLAMES}',
        No_Permission = '^1[^5BadgerFires^1] ^1ERROR: You have no permission to start fires...',
        No_PermissionPreviewMode = '^1[^5BadgerFires^1] ^1ERROR: You have no permission to preview fires...',
        No_PermissionStopAll = '^1[^5BadgerFires^1] ^1ERROR: You do not have permission to run this command...',
    },
    General = {
        FireStarting = '^1[^5BadgerFires^1] ^3A fire is starting...',
        PreviewModeEnabled = '^1[^5BadgerFires^1] ^2Preview Mode ^3has been ^2ENABLED^3...',
        AllFiresStopped = '^1[^5BadgerFires^1] ^3All fires have been extinguished...!',
        FireStarted = '^1[^5BadgerFires^1] ^3A fire has started by ^3[^2{STARTER_ID}^3] ^2{STARTER_NAME}^3...',
        RandomFireAnnouncement = '^1[^5BadgerFires^1] ^3A fire has been spotted at ^6{NAME}^3...',
    },
}


-- ONLY ACTIVE IF `AnyoneCanUse` is set to false
Config.Permissions = {
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