local AddonName, OVERLAY = ...

OVERLAY.defaults = {
    classes = {
        ["WARLOCK"] = {
            alert = {
                [17941] = { -- Nightfall
                    [0] = true,
                },
                [34936] = { -- Backlash
                    [0] = true,
                },
                [71165] = { -- Molten Core
                    [0] = true, -- any stacks
                },
                [63167] = { -- Decimation
                    [0] = true,
                },
                [47283] = { -- Empowered Imp
                    [0] = true,
                },
            },
            glow = {
                [17941] = { -- Nightfall
                    [686] = true, -- Shadow Bolt
                },
                [34936] = { -- Backlash
                    [686]   = true, -- Shadow Bolt
                    [29722] = true, -- Incinerate
                },
                [71165] = { -- Molten Core
                    [29722] = true, -- Incinerate
                    [6353]  = true, -- Soul Fire
                },
                [63167] = { -- Decimation
                    [6353] = true, -- Soul Fire
                },
            },
        },
    },
    
}
