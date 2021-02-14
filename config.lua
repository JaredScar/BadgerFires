Config = {
    ParticleEffect = "ent_ray_ch2_farm_fire_dble",
    MaxSize = 500,
    MaxDensity = 500,
    MaxFlameScale = 500,
    Concurrent = 1,
    AnyoneCanUse = true, -- Anyone can use it? -- THIS WILL DISABLE PERMISSIONS
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