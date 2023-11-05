Config = {
    ParticleEffect = "ent_ray_ch2_farm_fire_dble",
    MaxSize = 500,
    MaxDensity = 500,
    MaxFlameScale = 500,
    Concurrent = 1,
    AnyoneCanUse = true, -- Anyone can use it? -- THIS WILL DISABLE PERMISSIONS
    RandomFireSpawning = true, -- Fires spawn randomly?
    RandomFireSpawningDelay = 1, -- After a fire randomly spawns, 1 minutes must pass before another one can be spawned
    RandomFireChance = 90, -- 90% chance of a fire starting
    RandomFireLocations = {
        { name = 'PD', x = 0, y = 0, z = 0 },
        { name = 'PD2', x = 0, y = 0, z = 0 },
    },
    VehicleEngineFires = true
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