local gui = require("gui")

local xml2lua = require("xml2lua")
-- Uses a handler that converts the XML to a Lua table
local handler = require("xmlhandler.tree")

local xml = [[
<people>
  <person type="natural">
    <name>Manoel</name>
    <city>Palmas-TO</city>
  </person>
  <person type="legal">
    <name>University of Brasília</name>
    <city>Brasília-DF</city>
  </person>
</people>
]]

-- Instantiates the XML parser
local parser = xml2lua.parser(handler)
parser:parse(xml)

local function parse_styles(styles)
    local result = {}

    -- Split the styles string by semicolon
    local styles_table = {}
    for style in styles:gmatch("([^;]+)") do
        table.insert(styles_table, style)
    end

    -- Process each style
    for _, style in ipairs(styles_table) do
        local key, value = style:match("^%s*(.-)%s*:%s*(.+)$")
        if key and value then
            -- Remove leading and trailing spaces
            key = key:gsub("^%s*(.-)%s*$", "%1")
            value = value:gsub("^%s*(.-)%s*$", "%1")

            -- Split values separated by spaces
            local values = {}
            for val in value:gmatch("%S+") do
                table.insert(values, val)
            end

            -- Convert numeric values to numbers
            local numeric_values = {}
            for _, val in ipairs(values) do
                local num = tonumber(val)
                if num then
                    table.insert(numeric_values, num)
                else
                    table.insert(numeric_values, val)
                end
            end

            -- Store the values
            if #numeric_values == 1 then
                result[key] = numeric_values[1]
            else
                result[key] = numeric_values
            end
        end
    end

    return result
end

function print_table(tab, indent)
    indent = indent or "" -- Initialize the indentation string if not provided
  
    for key, value in pairs(tab) do
      local key_type = type(key)
      local value_type = type(value)
  
      -- Print the current key and value
      if key_type == "number" then
        print(indent .. "[" .. key .. "] = " .. tostring(value))
      else
        print(indent .. "['" .. key .. "'] = " .. tostring(value))
      end
  
      -- If the value is a table, recursively print its structure
      if value_type == "table" then
        print(indent .. "{")
        print_table(value, indent .. "  ")
        print(indent .. "}")
      end
    end
  end

-- Example usage
local styles = "border: 5px solid red; color: #ff0000; font-size: 14px; margin: 10px 20px 30px 40px;"
local parsed_styles = parse_styles(styles)

-- Print the parsed styles
print_table(parsed_styles)
