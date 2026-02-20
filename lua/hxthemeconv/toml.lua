local M={}

local function encode_value_number(val)
  if math.floor(val)==val
    and -2^63<=val and val<2^63 then
    return ('%d'):format(val)
  end
  return ('%f'):format(val)
end

local function encode_value_boolean(val)
  return tostring(val)
end

local function encode_value_string(val)
  return ('%q'):format(val)
end

local encode_value
local function encode_value_table(val)
  if vim.islist(val) then
    local entries={}
    for _,v in ipairs(val) do
      table.insert(entries,encode_value(v))
    end
    return '['..table.concat(entries,',')..']'
  end
  local entries={}
  for k,v in pairs(val) do
    if type(k)~='string' then
      error('expected all table keys to be string (or the table to be a list)')
    end
    table.insert(entries,('%q=%s'):format(k,encode_value(v)))
  end
  return '{'..table.concat(entries,',')..'}'
end

function encode_value(val)
  if type(val)=='table' then
    return encode_value_table(val)
  elseif type(val)=='number' then
    return encode_value_number(val)
  elseif type(val)=='boolean' then
    return encode_value_boolean(val)
  elseif type(val)=='string' then
    return encode_value_string(val)
  else
    error('cant encode type: '..type(val))
  end
end

function M.encode(obj,opts)
  if type(obj)~='table' then
    error('table expected, got: '..type(obj))
  end
  local lines={}
  for k,v in pairs(obj) do
    if type(k)~='string' then
      error('expected all table keys to be string')
    end
    table.insert(lines,('%q=%s'):format(k,encode_value(v)))
  end
  return lines
end

return M
