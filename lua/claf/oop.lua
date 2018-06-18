-- Object oriented programming features.

-- Class hierarchy root
Root = {
    __isclass = true
}

function isclass(any)
    if any == nil then return false end
    if not istable(any) then return false end
    return any.__isclass
end

function isobject(any)
    if any == nil then return false end
    if not istable(any) then return false end
    return any.__class ~= nil
end

local function createObject(cls, ...)
    -- local object = {}
    local object = table.Copy(cls)

    local mt = table.Copy(getmetatable(object))
    mt.__call = nil
    setmetatable(object, mt)

    -- local currentClass = cls
    -- local hierarchy = {cls}
    -- collectHierarchy(hierarchy, cls)
    -- construct(object, hierarchy)
    object.__isclass = nil
    object.__class = cls
    if object.__init == nil then
        function object:__init() end
    end
    object:__init(...)
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
    local newClass = table.Copy(body)

    -- for k, v in pairs(body) do
    --     newClass[k] = v
    -- end
    newClass.__super = super
    setmetatable(newClass, {
        __call = function(cls, ...) return createObject(cls, ...) end,
        __index = super
    })
    return newClass
end

function finishclass(cls)
    local mt = table.Copy(cls)
    function mt:__call(a, ...)
        return createObject(cls, ...)
    end
    setmetatable(cls, mt)
end
