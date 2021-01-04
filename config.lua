Config = {
    MaxSize = 5,
    MaxDensity = 5,
    MaxFlameScale = 5,
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