include 'claf.lua'

-- Unit tests.

local tests = {
    --- Self-test ---

    function()
        print 'Running CLAF tests...'
    end,

    --- Alias tests ---

    function()
        print 'Alias "GetHealth"...'

        local health = Entity(1):Health()
        local getHealth = Entity(1):GetHealth()

        assert(health == getHealth)
    end,
    function()
        print 'Alias "IsAlive"...'

        local alive = player.GetAll()[1]:Alive()
        local isAlive = player.GetAll()[1]:IsAlive()

        assert(alive == isAlive)
    end,
    function()
        print 'Alias "GetArmor"...'

        local armor = player.GetAll()[1]:Armor()
        local getArmor = player.GetAll()[1]:GetArmor()

        assert(armor == getArmor)
    end,
    function()
        print 'Alias "Run"...'

        Run 'x_ = 1'

        assert(x_ == 1)
    end,

    --- Enums and Flags tests ---

    function()
        print 'Enum structure...'

        local color = Enum('RED', 'GREEN', 'BLUE')

        assertNotNil(color.RED)
        assertNotNil(color.GREEN)
        assertNotNil(color.BLUE)
    end,
    function()
        print 'Flags structure...'

        local color = Flags('RED', 'GREEN', 'BLUE')

        assertNotNil(color.RED)
        assertNotNil(color.GREEN)
        assertNotNil(color.BLUE)
    end,
    function()
        print 'Empty enum...'

        local empty = Enum()

        assert(#empty == 0)
    end,
    function()
        print 'Empty flags...'

        local empty = Flags()

        assert(#empty == 0)
    end,
    function()
        print 'Incorrect enum constant names...'

        assertError(Enum('RED.smth'))
        assertError(Enum('4abc'))
        assertError(Enum('!@#$%^&*'))
        assertError(Enum('smth()'))
        assertError(Enum('"'))
        assertError(Enum(''))
        assertError(Enum('_4'))
        assertError(Enum('__'))
        assertError(Enum('_a'))
    end,
    function()
        print 'Incorrect flags constant names...'

        assertError(Flags('RED.smth'))
        assertError(Flags('4abc'))
        assertError(Flags('!@#$%^&*'))
        assertError(Flags('smth()'))
        assertError(Flags('"'))
        assertError(Flags(''))
        assertError(Flags('_4'))
        assertError(Flags('__'))
        assertError(Flags('_a'))
    end,
    function()
        print 'Flag batching/debatching...'

        local color = Flags('RED', 'GREEN', 'BLUE')

        local greenAndBlue = bit.bor(color.GREEN, color.BLUE)
        -- RED                  1   001
        -- GREEN                2   010
        -- BLUE                 4   100
        -- bit.bor(GREEN, BLUE) 6   110
        assert(greenAndBlue == 6)
        assert(bit.band(greenAndBlue, color.GREEN) == color.GREEN)
        assert(bit.band(greenAndBlue, color.BLUE) == color.BLUE)
    end,

    --- Functional programming ---

    function()
        print 'Map()...'

        local numbers = {1, 2, 3, 4, 5}

        numbers = Map(function(x) return x * 2 end, numbers)

        assert(numbers[1] == 2)
        assert(numbers[2] == 4)
        assert(numbers[3] == 6)
        assert(numbers[4] == 8)
        assert(numbers[5] == 10)
    end,
    function()
        print 'Map() with empty table...'

        local empty = {}

        local emptyToo = Map(function(x) return x * 2 end, empty)

        assert(#emptyToo == 0)
    end,
    function()
        print 'Filter()...'

        local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

        numbers = Filter(function(x) return IsEven(x) end, numbers)

        assert(numbers[1] == 2)
        assert(numbers[2] == 4)
        assert(numbers[3] == 6)
        assert(numbers[4] == 8)
        assert(numbers[5] == 10)
    end,
    function()
        print 'Filter() with empty table...'

        local empty = {}

        local emptyToo = Filter(function(x) return true end, empty)

        assert(#emptyToo == 0)
    end,
    function()
        print 'Any()...'

        local numbers = {2, 20, 100, 1}

        anyIsOdd = Any(numbers, function(x) return IsOdd(x) end)

        assert(anyIsOdd)
    end,
    function()
        print 'Any() with default predicate...'

        local numbers = {true, false, false, true}

        any = Any(numbers)

        assert(any)
    end,
    function()
        print 'Any() with empty table...'

        local empty = {}

        local shouldBeFalse = Any(empty)

        assertNot(shouldBeFalse)
    end,
    function()
        print 'All()...'

        local numbers = {2, 20, 100, 1}

        allIsOdd = All(numbers, function(x) return IsOdd(x) end)

        assertNot(allIsOdd)
    end,
    function()
        print 'All() with default predicate...'

        local numbers = {true, true}

        all = All(numbers)

        assert(all)
    end,
    function()
        print 'All() with empty table...'

        local empty = {}

        local shouldBeFalse = All(empty)

        assertNot(shouldBeFalse)
    end,
    function()
        print 'None()...'

        local numbers = {2, 20, 100, 1}

        allIsOdd = None(numbers, function(x) return IsOdd(x) end)

        assertNot(allIsOdd)
    end,
    function()
        print 'None() with default predicate...'

        local numbers = {true, false}

        all = None(numbers)

        assertNot(all)
    end,
    function()
        print 'None() with empty table...'

        local empty = {}

        local shouldBeFalse = None(empty)

        assertNot(shouldBeFalse)
    end,

    --- Zip ---

    function()
        print 'Zip() (same source lengths)...'

        local a = {1, 2, 3}
        local b = {4, 5, 6}
        local c = {7, 8, 9}

        local zip = Zip(a, b, c)

        assert(zip[1][1] == 1)
        assert(zip[1][2] == 4)
        assert(zip[1][3] == 7)
        assert(zip[2][1] == 2)
        assert(zip[2][2] == 5)
        assert(zip[2][3] == 8)
        assert(zip[3][1] == 3)
        assert(zip[3][2] == 6)
        assert(zip[3][3] == 9)
    end,
    function()
        print 'Zip() (different source lengths)...'

        local a = {1, 2, 3}
        local b = {4, 5, 6, 7}
        local c = {8, 9, 10, 11, 12}

        local zip = Zip(a, b, c)

        assert(zip[1][1] == 1)
        assert(zip[1][2] == 4)
        assert(zip[1][3] == 8)
        assert(zip[2][1] == 2)
        assert(zip[2][2] == 5)
        assert(zip[2][3] == 9)
        assert(zip[3][1] == 3)
        assert(zip[3][2] == 6)
        assert(zip[3][3] == 10)
        assert(#zip == 3)
        assert(#zip[1] == 3)
        assert(#zip[2] == 3)
        assert(#zip[3] == 3)
    end,

    --- Try/catch ---

    function()
        print 'Try with catch...'

        local x
        local wrong = function()
            Try(function()
                __nothing__.foo = 1
            end,
            -- catch
            function()
                x = 2
            end)
        end

        assertNoError(wrong)
        assert(x == 2)
    end,
    function()
        print 'Try (error occurs) with finally...'

        local x
        local wrong = function()
            Try(function()
                __nothing__.foo = 1
            end,
            nil,
            -- finally
            function()
                x = 2
            end)
        end

        assertNoError(wrong)
        assert(x == 2)
    end,
    function()
        print 'Try (error does not occur) with finally...'

        local x
        local wrong = function()
            Try(function() end,
            nil,
            -- finally
            function()
                x = 2
            end)
        end

        assertNoError(wrong)
        assert(x == 2)
    end,

    --- Min and Max ---

    function()
        print 'Min()...'

        local tbl = {2, 5, 34, 73, 1, 6}

        local min = Min(tbl)

        assert(min == 1)
    end,
    function()
        print 'Max()...'

        local tbl = {2, 5, 34, 73, 1, 6}

        local max = Max(tbl)

        assert(max == 73)
    end,
    function()
        print 'Min(), Max() with empty table...'

        local tbl = {}

        local min = Min(tbl)
        local max = Max(tbl)

        assertNil(min)
        assertNil(max)
    end,

    --- Object oriented programming ---

    function()
        print 'Object creation & structure...'

        local cls = class {
            foo = 1,
            bar = 3
        }

        local obj = cls()

        assert(obj.foo == 1)
        assert(obj.bar == 3)
    end,
    function()
        print 'Object field edit...'

        local cls = class {
            foo = 1,
            bar = 3
        }

        local obj = cls()
        obj.foo = 4

        assert(obj.foo == 4)
        assert(obj.bar == 3)
    end,
    function()
        print 'Constructor without parameters...'

        local cls = class {
            foo = 1,
            bar = 3
        }
        function cls:__init()
            self.foo = 2
        end

        local obj = cls()

        assert(obj.foo == 2)
        assert(obj.bar == 3)
    end,
    function()
        print 'Constructor with parameters...'

        local cls = class {
            foo = 1,
            bar = 3
        }
        function cls:__init(a)
            self.foo = a
        end

        local obj = cls(2)

        assert(obj.foo == 2)
        assert(obj.bar == 3)
    end,
    function()
        print 'Class inheritance (without constructor)...'

        local base = class {
            foo = 1,
            bar = 2
        }

        local derived = class({
            foo = 5,
            boo = 6
        }, base)

        local obj = derived()

        assert(obj.foo == 5)
        assert(obj.bar == 2)
        assert(obj.boo == 6)
    end,
    function()
        print 'Class inheritance (with constructor, no call to super)...'

        local buffer = ''

        local base = class{}
        function base:__init()
            buffer = buffer..'a'
        end

        local derived = class({}, base)
        function derived:__init()
            buffer = buffer..'b'
        end

        local obj = derived()

        assert(buffer == 'b')
    end,
    function()
        print 'Class inheritance (with constructor, call to super)...'

        local buffer = ''

        local base = class{}
        function base:__init()
            buffer = buffer..'a'
        end

        local derived = class({}, base)
        function derived:__init()
            self.__super:__init()
            buffer = buffer..'b'
        end

        local obj = derived()

        assert(buffer == 'ab')
    end,
    function()
        print 'isclass()...'

        local cls = class {
            foo = 1,
            bar = 3
        }

        assert(isclass(cls))
    end,
    function()
        print 'isobject()...'

        local cls = class {
            foo = 1,
            bar = 3
        }

        local obj = cls()

        assert(isobject(obj))
    end,
    function()
        print 'Operator overloading...'

        local str
        local cls = class {}
        function cls:__init(val) self.val = val end
        function cls:__add(a, b)
            str = a.val..b.val
            print(a.val)
            print(b.val)
        end
        finishclass(cls)
        local obj1 = cls(1)
        local obj2 = cls(2)
        local x = obj1 + obj2

        print(str)
        assert(str == '12')
    end,

    --- Tests success ---

    function()
        print 'CLAF tests successful!'
    end
}

print 'CLAF Tests table initialized'

for _, test in pairs(tests) do
    test()
end
