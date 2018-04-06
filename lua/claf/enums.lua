local function checkName(name)
    if #name == 0 then
        error 'empty enum constant'
    end
    
    local numbers = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' }
    for i = 1, #numbers do
        if string.StartWith(name, numbers[i]) then
            error 'enum constant cannot start with a number'
        end
    end

    local allowedSymbols = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i',
        'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '_' }
    for i = 1, #allowedSymbols do
        name = string.Replace(name, allowedSymbols[i], '')
        name = string.Replace(name, string.upper(allowedSymbols[i]), '')
    end
    if #name ~= 0 then
        error 'bad enum constant'
    end
end

-- Creates an enum.
function Enum(constants)
    if not istable(constants) then error '"constants" must be a table of strings' end
    local enum = {}

    local constantValue = 1
    for _, constantName in pairs(constants) do
        checkName(constantName)
        if not isstring(constantName) then error '"constants" must be a table of strings' end
        enum[constantName] = constantValue
        constantValue = constantValue + 1
    end

    return enum
end

-- Creates a flag set.
function Flags(constants)
    if not istable(constants) then error '"constants" must be a table of strings' end
    local flagSet = {}

    local currentFlagValue = 1
    for _, flagName in pairs(constants) do
        checkName(flagName)
        if not isstring(flagName) then error '"constants" must be a table of strings' end
        flagSet[flagName] = currentFlagValue
        currentFlagValue = currentFlagValue * 2
    end

    return flagSet
end

Combine = bit.bor
Extract = bit.band
