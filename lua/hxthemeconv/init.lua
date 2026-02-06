local conv_tbl_base=require'hxthemeconv.conv_tbl.base'
local toml=require'hxthemeconv.toml'

local function to_hx_theme_key(conv_key,conv_val)
  local function recursive(val)
    if val==false then
      return {}
    elseif type(val)=='function' then
      return val(recursive,conv_key,conv_val)
    elseif type(val)=='string' then
      hl_info=vim.api.nvim_get_hl(0,{name=val,link=false,create=false})
      return hl_info.link and {} or hl_info
    end
    error('val needs to be one of false, function or string, got: '..(val==true and 'true' or type(val)))
  end

  local hl_info=recursive(conv_val)

  local function color_to_hex(color)
    return color and string.format('#%06x',color)
  end

  local attr_to_modifier={
    bold='bold',
    strikethrough='crossed_out',
    italic='italic',
    reverse='reversed',
  }

  local attr_to_underline={
    {'underline','line'},
    {'undercurl','curl'},
    {'underdouble','double_line'},
    {'underdotted','dotted'},
    {'underdashed','dashed'},
  }

  local modifiers={}
  for k,v in pairs(attr_to_modifier) do
    if hl_info[k] then
      table.insert(modifiers,v)
    end
  end

  local underline
  for _,i in ipairs(attr_to_underline) do
    local k,v=unpack(i)
    if hl_info[k] then
      underline={style=v,color=color_to_hex(hl_info.sp)}
    end
  end

  local ret_tbl={
    underline=underline,
    modifiers=next(modifiers) and modifiers,
    fg=color_to_hex(hl_info.fg),
    bg=color_to_hex(hl_info.bg),
  }
  return next(ret_tbl) and ret_tbl or nil
end

local function generate_theme(conv_tbl)
  local theme={}
  for k,v in pairs(conv_tbl) do
    theme[k]=to_hx_theme_key(k,v)
  end
  return theme
end

local M={}

function M.run(conv_tbl)
  conv_tbl=vim.tbl_extend('force',conv_tbl_base,conv_tbl or {})

  local theme=generate_theme(conv_tbl)

  return toml.encode(theme)
end

return M
