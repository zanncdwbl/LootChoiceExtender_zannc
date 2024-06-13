function printTable(tbl, indent)
    indent = indent or 0
    local formatting = string.rep("  ", indent)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(formatting .. k .. ":")
            printTable(v, indent + 1)
        else
            print(formatting .. k .. ": " .. tostring(v))
        end
    end
end

GUISJSONFile = rom.path.combine(rom.paths.Content, 'Game/Obstacles/GUI.sjson')

Order = {
    'Name',
    'InheritFrom',
    'DisplayInEditor',
    'Thing'
}

-- Just creating a new set of data to change per room
NewDataBoonsSlotBase = sjson.to_object({
    Name = "BoonSlotBaseExtraOptions",
    InheritFrom = "BaseInteractableButton",
    DisplayInEditor = false,
    Thing = {
        TimeModifierFraction = 0.0,
        EditorOutlineDrawBounds = false,
        Graphic = "BoonSlotBase",
        Interact =
        {
            HighlightOnAnimation = "null",
            HighlightOffAnimation = "null",
        },
        Points = {
            { X = -490, Y = 110 },
            { X = 600,  Y = 110 },
            { X = 600,  Y = -110 },
            { X = -490, Y = -110 },
        }
    },
}, Order)

sjson.hook(GUISJSONFile, function(data)
    table.insert(data.Obstacles, NewDataBoonsSlotBase)
end)

-- -- Scaling button **hitbox** based on config option
-- local excess = math.max(3, CalcNumLootChoices()) - 3
-- local squash = 3 / (3 + excess)

sjson.hook(GUISJSONFile, function(data)
    for _, v in ipairs(data.Obstacles) do
        if v.Name == "BoonSlotBaseExtraOptions" then
            if SquashYScale ~= nil then
                v.Thing.Points = {
                    { X = -490, Y = 110 * SquashYScale },
                    { X = 600,  Y = 110 * SquashYScale },
                    { X = 600,  Y = -110 * SquashYScale },
                    { X = -490, Y = -110 * SquashYScale },
                }
            end
        end
    end
end)
