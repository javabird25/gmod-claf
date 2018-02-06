-- Object oriented programming features.

-- Class hierarchy root
Root = {
    __isclass = true
}

function isclass(any)
    if any == nil return false
    return any.__isclass
end

local function createObject(cls, ...)
    -- local object = {}
    local object = table.Copy(cls)
    setmetatable(object, {})
    local currentClass = cls
    local hierarchy = {cls}
    -- collectHierarchy(hierarchy, cls)
    -- construct(object, hierarchy)
    object.__isclass = nil
    object.__class = cls
    object:__init(unpack(...))
    return object
end

-- local function collectHierarchy(hierarchy, cls)
--     while isclass(currentClass.__super) do
--         table.insert(hierarchy, currentClass.__super)
--         currentClass = currentClass.__super
--     end
--     table.insert(hierarchy, currentClass.__super)
-- end
--
-- local function construct(object, hierarchy)
--     for i = #hierarchy, 1, -1 do
--         increaseMembers(object, hierarchy[i])
--         object:__init()
--     end
-- end
--
-- local function increaseMembers(object, cls)
--     for k, v in pairs(cls) do
--         object[k] = v
--     end
-- end

-- Creates a new class.
function class(body, super)
    super = super or Root
    local newClass = table.Copy()

    -- for k, v in pairs(body) do
    --     newClass[k] = v
    -- end
    newClass.__super = superClass
    setmetatable(newClass, {
        __call = function(cls, ...) return createObject(cls, unpack(...)) end
    })
    return newClass
end
