local M = {}

M.__daysBefore = {
    [1] = 0,
    [2] = 31,
    [3] = 59,
    [4] = 90,
    [5] = 120,
    [6] = 181,
    [7] = 212,
    [8] = 243,
    [9] = 273,
    [10] = 304,
    [11] = 334,
}

M.__daysOfMonth = {
    [1] = 31,
    [2] = 29,
    [3] = 31,
    [4] = 30,
    [5] = 31,
    [6] = 30,
    [7] = 31,
    [8] = 31,
    [9] = 30,
    [10] = 31,
    [11] = 30,
    [12] = 31,
}

M.__monthName = {
    [1] = "January",
    [2] = "February",
    [3] = "March",
    [4] = "April",
    [5] = "May",
    [6] = "June",
    [7] = "July",
    [8] = "August",
    [9] = "September",
    [10] = "October",
    [11] = "November",
    [12] = "December",
}
M.__dayName = {
    [1] = "Sunday",
    [2] = "Monday",
    [3] = "Tuesday",
    [4] = "Wednesday",
    [5] = "Thursday",
    [6] = "Friday",
    [7] = "Saturday",
}
M.__getDate = function(time)
    -- if time provided, return date generated with argument
    if time then
        return os.date("*t", time)
    else
        -- if time not provided, return date generated with current time
        return os.date("*t")
    end
end

M.__isLeapYear = function(year)
    -- All years that are divisible by 4 are leap years,
    -- unless they start a new century, provided they
    -- are not divisible by 400.
    return not (year % 4) and (year % 100) or not (year % 400)
end

M.__getLastDay = function(year, month)
    if month == 0 then
        return M.__daysOfMonth[12]
    elseif month == 2 then
        if M.__isLeapYear(year) then
            return (M.__daysOfMonth[month] - 1)
        else
            return M.__daysOfMonth[month]
        end
    else
        return M.__daysOfMonth[month]
    end
end

M.__getMonthName = function(month)
    return M.__monthName[month]
end
M.__getDayName = function(wday)
    return M.__dayName[wday]
end

M.getDate = function()
    -- return easy-to use date data
    local date = M.__getDate()

    local D = {
        ["prevMonthLastDay"] = M.__getLastDay(date.year, date.month - 1),
        ["currentMonthLastDay"] = M.__getLastDay(date.year, date.month),
        ["currentMonthfirstDayWday"] = (date.wday - date.day % 7 + 7 + 1) % 7,
        ["year"] = date.year,
        ["month"] = date.month,
        ["day"] = date.day,
        ["wday"] = date.wday,
        ["monthName"] = M.__getMonthName(date.month),
        ["dayName"] = M.__getDayName(date.wday),
    }
    return D
end

---------------------------------------------------------------------------------------------------------------------------------

-- Output 1
-- ┌──────────────────────────────────────────────────────────────┐
-- │                     Sunday May 14 2023                       │
-- ├────────┬────────┬────────┬────────┬────────┬────────┬────────┤
-- │ ☀️  Sun │ 🌕 Mon │ 🔥 Tue │ 🌊 Wed │ 🪵 Thu │ 🥇 Fri │ 🏖️ Sat │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │   30   │    1   │    2   │    3   │    4   │    5   │    6   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │    7   │    8   │    9   │   10   │   11   │   12   │   13   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │ ✅(14) │   15   │   16   │   17   │   18   │   19   │   20   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │   21   │   22   │   23   │   24   │   25   │   26   │   27   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │   28   │   29   │   30   │   31   │   01   │   02   │   03   │
-- └────────┴────────┴────────┴────────┴────────┴────────┴────────┘

-- Output 2
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                     Sunday May 14 2023                       ║
-- ╠════════╦════════╦════════╦════════╦════════╦════════╦════════╣
-- ║ ☀️  Sun ║ 🌕 Mon ║ 🔥 Tue ║ 🌊 Wed ║ 🪵 Thu ║ 🥇 Fri ║ 🏖️ Sat ║
-- ╚════════╩════════╩════════╩════════╩════════╩════════╩════════╝
-- ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
-- │   23   │   24   │   25   │   26   │   27   │   28   │   29   │
-- ├────────╆━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┪
-- │   30   ┃    1   │    2   │    3   │    4   │    5   │    6   ┃
-- ┢━━━━━━━━╃────────┼────────┼────────┼────────┼────────┼────────┨
-- ┃    7   │    8   │    9   │   10   │   11   │   12   │   13   ┃
-- ┠────────┼────────┼────────┼────────┼────────┼────────┼────────┨
-- ┃ ✅(14) │   15   │   16   │   17   │   18   │   19   │   20   ┃
-- ┠────────┼────────┼────────┼────────┼────────┼────────┼────────┨
-- ┃   21   │   22   │   23   │   24   │   25   │   26   │   27   ┃
-- ┠────────┼────────┼────────╆━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┩
-- ┃   28   │   29   │   30   ┃   31   │   01   │   02   │   03   │
-- ┡━━━━━━━━┿━━━━━━━━┿━━━━━━━━╃────────┼────────┼────────┼────────┤
-- │   04   │   05   │   06   │   07   │   08   │   09   │   10   │
-- └────────┴────────┴────────┴────────┴────────┴────────┴────────┘

-- Output 3
-- ╔══════════════════════════════════════════════════════════════╗
-- ║                     Sunday May 14 2023                       ║
-- ╠════════╦════════╦════════╦════════╦════════╦════════╦════════╣
-- ║ ☀️  Sun ║ 🌕 Mon ║ 🔥 Tue ║ 🌊 Wed ║ 🪵 Thu ║ 🥇 Fri ║ 🏖️ Sat ║
-- ╚════════╩════════╩════════╩════════╩════════╩════════╩════════╝
--┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
--│   23   │   24   │   25   │   26   │   27   │   28   │   29   │
--├────────┼────────┴────────┴────────┴────────┴────────┴────────┘
--│   30   │┌────────┬────────┬────────┬────────┬────────┬────────┐
--└────────┘│    1   │    2   │    3   │    4   │    5   │    6   │
-- ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │    7   │    8   │    9   │   10   │   11   │   12   │   13   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │ ✅(14) │   15   │   16   │   17   │   18   │   19   │   20   │
-- ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
-- │   21   │   22   │   23   │   24   │   25   │   26   │   27   │
-- ├────────┼────────┼────────┼────────┼────────┴────────┴────────┘
-- │   28   │   29   │   30   │   31   │┌────────┬────────┬────────┐
-- └────────┴────────┴────────┴────────┘│   01   │   02   │   03   │
--  ┌────────┬────────┬────────┬────────┼────────┼────────┼────────┤
--  │   04   │   05   │   06   │   07   │   08   │   09   │   10   │
--  └────────┴────────┴────────┴────────┴────────┴────────┴────────┘

-- Output 4
-- ┌─────────────────────────────────────────┐
-- │            Sunday May 14 2023           │
-- ├─────┬─────┬─────┬─────┬─────┬─────┬─────┤
-- │ Sun │ Mon │ Tue │ Wed │ Thu │ Fri │ Sat │
-- ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
-- │  30 │  1  │  2  │  3  │  4  │  5  │  6  │
-- ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
-- │  7  │  8  │  9  │  10 │  11 │  12 │  13 │
-- ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
-- │✅14 │  15 │  16 │  17 │  18 │  19 │  20 │
-- ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
-- │  21 │  22 │  23 │  24 │  25 │  26 │  27 │
-- ├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
-- │  28 │  29 │  30 │  31 │  01 │  02 │  03 │
-- └─────┴─────┴─────┴─────┴─────┴─────┴─────┘
-- Output 5
-- ┌───────────────────────────┐
-- │    Sunday May 14 2023     │
-- ├───┬───┬───┬───┬───┬───┬───┤
-- │ S │ M │ T │ W │ T │ F │ S │
-- ├───┼───┼───┼───┼───┼───┼───┤
-- │ 30│ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │
-- ├───┼───┼───┼───┼───┼───┼───┤
-- │ 7 │ 8 │ 9 │ 10│ 11│ 12│ 13│
-- ├───┼───┼───┼───┼───┼───┼───┤
-- │*14│ 15│ 16│ 17│ 18│ 19│ 20│
-- ├───┼───┼───┼───┼───┼───┼───┤
-- │ 21│ 22│ 23│ 24│ 25│ 26│ 27│
-- ├───┼───┼───┼───┼───┼───┼───┤
-- │ 28│ 29│ 30│ 31│ 01│ 02│ 03│
-- └───┴───┴───┴───┴───┴───┴───┘

M.__Header = function(dayName, monthName, day, year)
    local mid = dayName .. " " .. monthName .. " " .. day .. " " .. year
    local spaces = (62 - string.len(mid))
    local paddingL = (" "):rep(spaces / 2 + spaces % 2)
    local paddingR = (" "):rep(spaces / 2)
    -- return "│" .. paddingL .. mid .. paddingR .. "│\n"
    return " " .. paddingL .. mid .. paddingR .. " \n"
end

M.date = M.getDate()

M.createOutput = function()
    local date = M.date
    local start = date.prevMonthLastDay - date.currentMonthfirstDayWday + 2
    local pos = { ["line"] = 1, ["col"] = 1 }

    local days = ""

    for i = start, date.prevMonthLastDay, 1 do
        -- days = days .. "│   " .. i .. "   "
        days = days .. "    " .. " ˗" .. "   "
        -- days = days .. "         "
        pos.col = pos.col + 1
    end

    for i = 1, date.currentMonthLastDay, 1 do
        local paddingL
        local paddingR
        local day = ""
        if i == date.day then
            -- day = "✅(" .. i .. ")"
            day = "  ❰ " .. i .. " ❱ "
            if i >= 10 then
                day = " ❰ " .. i .. " ❱ "
            end
            paddingL = (" "):rep((8 - string.len(day)) / 2 + (8 - string.len(day)) % 2)
            -- paddingL = (" "):rep((8 - string.len(day)) / 2 + (8 - string.len(day)) % 2 - 1)
            paddingR = (" "):rep((8 - string.len(day)) / 2 + 1)
        else
            day = "" .. i
            paddingL = (" "):rep((8 - string.len(day)) / 2 + (8 - string.len(day)) % 2)
            paddingR = (" "):rep((8 - string.len(day)) / 2)
        end

        -- days = days .. "│" .. paddingL .. day .. paddingR
        days = days .. " " .. paddingL .. day .. paddingR
        if pos.col == 7 then
            days = days
                -- .. "│\n"
                -- .. " \n"
                -- .. "├────────┼────────┼────────┼────────┼────────┼────────┼────────┤\n"
                .. "\n"
            pos.col = 1
            pos.line = pos.line + 1
        else
            pos.col = pos.col + 1
        end
    end

    if pos.col > 1 then
        local nextday = 1
        for i = pos.col, 7, 1 do
            -- days = days .. "│   " .. "0" .. nextday .. "   "
            days = days .. "    " .. " ˗" .. "   "
            -- days = days .. "         "
            nextday = nextday + 1
        end
        days = days .. "\n"
    end

    -- days = days .. "│\n"
    -- days = days
    -- .. "└────────┴────────┴────────┴────────┴────────┴────────┴────────┘"
    -- .. ""

    -- local output = (
    --     "┌──────────────────────────────────────────────────────────────┐\n"
    --     .. M.__Header(date.dayName, date.monthName, date.day, date.year)
    --     .. "├────────┬────────┬────────┬────────┬────────┬────────┬────────┤\n"
    --     .. "│ ☀️  Sun │ 🌕 Mon │ 🔥 Tue │ 🌊 Wed │ 🪵 Thu │ 🥇 Fri │ 🏖️ Sat │\n"
    --     .. "├────────┼────────┼────────┼────────┼────────┼────────┼────────┤\n"
    --     .. days
    -- )

    local s = (date.monthName .. " - " .. date.year)
    -- local p = (" "):rep(62 - #s)
    local p = ""

    local output = (
        p
        .. " "
        .. string.upper(s)
        .. "\n"
        .. "┌──────────────────────────────────────────────────────────────┐\n"
        -- .. M.__Header(date.dayName .. ",", date.monthName, date.day, date.year)
        -- .. "└──────────────────────────────────────────────────────────────┘\n"
        .. "   Sun      Mon      Tue      Wed      Thu      Fri      Sat    \n"
        .. "├──────────────────────────────────────────────────────────────┤\n"
        -- .. "   ───      ───      ───      ───      ───      ───      ───    \n"
        .. days
        .. "└──────────────────────────────────────────────────────────────┘\n"
    )
    return output
end

return M
