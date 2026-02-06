# [Neovim colorscheme to Helix theme converter](https://github.com/altermo/nvim-helix-theme-converter)

Converts active Neovim colorscheme to Helix theme

Quick usage:
```lua
vim.fn.writefile(require'hxthemeconv'.run(),'/tmp/outfile.toml')
```

Run options:
```lua
require'hxthemeconv'.run{
    -- The default can be found in: ./lua/hxthemeconv/conv_tbl/base.lua
    -- Places rules here to override default

    -- See https://docs.helix-editor.com/themes.html#scopes for keys

    -- Examples:

    -- make `ui.statusline` use `Error` highlighting
    ['ui.statusline']='Error',

    -- make `ui.cursor.match` not use any highlighting
    ['ui.cursor.match']=false,

    -- make `ui.cursor.primary` use a function to get the highlighting
    ['ui.cursor.primary']=function(recursive,key)
        -- `recursive` : function to get hl_info of a highlighting group
        -- `key` : the key of the rule (in this case `'ui.cursor.primary'`)
        -- return should be hl_info (e.g. table, NOT nil, NOT false)
        -- hl_info is `vim.api.keyset.get_hl_info` (see `:help nvim_get_hl`)
        -- an empty hl_info is the same as no value

        -- Example:
        -- Use `MultiCursorMain` if exists (and non-cleared), otherwise fallback to `Cursor`
        local hl_info=recursive'MultiCursorMain'
        if not vim.tbl_isempty(hl_info) then
            return hl_info
        end
        return recursive'Cursor'
    end,
}
```
