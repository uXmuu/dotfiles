call plug#begin()
"Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'Yggdroot/indentLine'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
call plug#end()

inoremap < <Esc>
noremap <C-h> :tabp<Enter>
noremap <C-l> :tabn<Enter>
noremap <C-t> :tabnew<Enter>
noremap <C-q> :q!<Enter>
noremap <C-w> :wq!<Enter> 


"inoremap <Tab> <Control>d

"something
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set nobackup
set incsearch

"theme
set nu
set statusline =
set statusline+=\ %F
set statusline+=\ %R
set statusline+=\ %M

set statusline+=%=
"set statusline+=LEAN
"set statusline+=VIM
"set statusline+=%=

set statusline+=\ %p%%



"let g:indentLine_color_gui = '#A4E57E'
"let g:indentLine_color_tty_light = 235
"let g:indentLine_color_dark = 1
"let g:indentLine_bgcolor_term = 202
let g:indentLine_char = '▏'

let g:pretty_indent_namespace = nvim_create_namespace('pretty_indent')

function! PrettyIndent()
let l:view=winsaveview()
call cursor(1, 1)
call nvim_buf_clear_namespace(0, g:pretty_indent_namespace, 1, -1)
while 1
    let l:match = search('^$', 'W')
    if l:match ==# 0
        break
    endif
    let l:indent = cindent(l:match)
    if l:indent > 0
        call nvim_buf_set_virtual_text(
        \   0,
        \   g:pretty_indent_namespace,
        \   l:match - 1,
        \   [[repeat(repeat(' ', &shiftwidth - 1) . '▏', l:indent / &shiftwidth), 'IndentGuide']],
        \   {}
        \)
    endif
endwhile
call winrestview(l:view)
endfunction

augroup PrettyIndent
"automd!
autocmd TextChanged * call PrettyIndent()
autocmd BufEnter * call PrettyIndent()
autocmd InsertLeave * call PrettyIndent()
augroup ENDc
retab1
colorscheme lean
set laststatus=2
"hi StatusLine ctermbg=1 ctermfg=11

"lua require("indent_blankline").setup()

"vim.opt.listchars:append("eol:↴")

lua <<EOF

EOF

lua require('nvim-tree').setup()

let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
"let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
\ 'git': 1,
\ 'folders': 0,
\ 'files': 0,
\ 'folder_arrows': 0,
\ }
let g:nvim_tree_icons = {
\ 'default': '',
\ 'symlink': '',
\ 'git': {
\   'unstaged': "",
\   'staged': "",
\   'unmerged': "",
\   'renamed': "",
\   'untracked': "",
\   'deleted': "",
\   'ignored': ""
\   },
\ 'folder': {
\   'arrow_open': "",
\   'arrow_closed': "",
\   'default': "",
\   'open': "",
\   'empty': "",
\   'empty_open': "",
\   'symlink': "",
\   'symlink_open': "",
\   }
\ }


nnoremap <C-n> :NvimTreeToggle<CR>
inoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

hi Pmenu ctermfg=lightblue ctermbg=233
hi PmenuSbar ctermfg=233 ctermbg=233
hi PmenuThumb ctermfg=236 ctermbg=236
hi NvimTreeEmptyFolderName ctermfg=cyan
hi NvimTreeRootFolder ctermfg=green  
hi NvimTreeNormal ctermfg=green
hi NvimTreeVertSplit ctermfg=239 ctermbg=233
hi VertSplit ctermfg=233 ctermbg=237
"hi Normal ctermbg=234
hi NvimTreeNormal ctermbg=233
hi NvimTreeImageFile ctermfg=magenta 
hi NvimTreeFolderName ctermfg=cyan


set completeopt=menu,menuone,noselect

lua <<EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --capabilities = capabilities
  --}
EOF

set fillchars+=vert:\▏

highlight! CmpItemAbbrMatch ctermfg=yellow
highlight! CmpItemAbbrMatchFuzzy ctermfg=cyan
highlight! CmpItemKindFunction ctermfg=lightmagenta
highlight! CmpItemKindMethod ctermfg=lightmagenta
highlight! CmpItemKindVariable ctermfg=green
highlight! CmpItemKindKeyword ctermfg=233

hi LineNr ctermfg=239 
