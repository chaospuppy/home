
"
" Load my vimrc
"

if exists('g:vscode')

else

    " Import the vimrc
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath
    source ~/.dotfiles/vim-config/vimrc

    """""""""""""""""""""""""""
    "
    " Plugins
    "
    " Using vim-plug - https://github.com/junegunn/vim-plug
    "
    """""""""""""""""""""""""""
    call plug#begin('~/.vim/plugged')

    Plug 'tomlion/vim-solidity'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'itchyny/lightline.vim'
    Plug 'tomtom/tcomment_vim'
    Plug 'easymotion/vim-easymotion'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
    Plug 'cespare/vim-toml'
    Plug 'itchyny/vim-gitbranch'
    Plug 'pangloss/vim-javascript'
    Plug 'elzr/vim-json'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'nvim-lua/plenary.nvim'
    Plug 'pmizio/typescript-tools.nvim'

    " Language specific
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    " Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'hashivim/vim-terraform'
    " Plug 'leafgarland/typescript-vim'
    Plug 'morhetz/gruvbox'
    Plug 'https://github.com/octol/vim-cpp-enhanced-highlight.git'
    Plug 'https://github.com/vim-python/python-syntax.git'
    Plug 'dhruvasagar/vim-table-mode'

    " Colorschemes
    Plug 'sjl/badwolf'
    Plug 'fatih/molokai'
    Plug 'sainnhe/gruvbox-material'

    call plug#end()
    """""""""""""""""""""""""""
    "
    " End Plugins
    "
    """""""""""""""""""""""""""

    " Set the color scheme
    " let g:rehash256 = 1
    " let g:molokai_original = 1
    " silent! color molokai
    silent! color gruvbox
    " silent! color badwolf

    " FZF mods
    map ; :Files<CR>

    " Note taking mods
    " map - :Note
    " let g:notes_directories = ['~/notes/']

    " LightLine mods
    let g:lightline = {
                \     'colorscheme': 'molokai',
                \
                \     'active': {
                \         'left': [ ['mode', 'paste' ],
                \                   ['gitbranch', 'readonly', 'filename', 'modified'] ],
                \
                \         'right': [ ['lineinfo'],
                \                    ['percent'],
                \                    ['fileformat', 'fileencoding', 'hexchar'] ]
                \     },
                \     'component': {
                \         'hexchar': '0x%B'
                \     },
                \     'component_function': {
                \         'gitbranch': 'gitbranch#name'
                \     },
                \ }

    " NOTE: Not required if using tree-sitter configuration below for go syntax highlighting
    " Golang Configuration
    " let g:go_highlight_types = 1
    " let g:go_highlight_extra_types = 1
    "
    " let g:go_highlight_fields = 1
    " let g:go_highlight_format_strings = 1
    " let g:go_highlight_variable_declarations = 1
    " let g:go_highlight_variable_assignments = 1
    "
    " let g:go_highlight_functions = 1
    " let g:go_highlight_function_calls = 1
    " let g:go_highlight_function_parameters = 1
    "
    " let g:go_highlight_operators = 1
    " let g:go_highlight_build_constraints = 1
    "
    " let g:go_highlight_array_whitespace_error = 1
    " let g:go_highlight_chan_whitespace_error = 1
    " let g:go_highlight_space_tab_error = 1

    let g:go_def_mode='gopls'
    let g:go_info_mode='gopls'
    let g:go_fmt_command = "gofmt"

    nmap <silent> <leader>gd :GoDef<CR>
    nmap <silent> <leader>gdp :GoDefPop<CR>
    " Golang Configuration


    " Language server configuration
    let g:LanguageClient_serverCommands = {
                \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
                \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
                \ 'python': ['pyls']
                \ }

    let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
    let g:LanguageClient_settingsPath = '${HOME}/.config/nvim/settings.json'
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient_textDocument_rangeFormatting()

    nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    " Language server configuration

    " Terraform Configs
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1
    " Terraform Configs

    " Python Configs
    let g:python_highlight_all = 1
    let g:python3_host_prog = expand('python')

    " NOTE: eventually, should move this entire config to lua
    lua << EOF
      require'typescript-tools'.setup {}
      require'lspconfig'.pyright.setup{}
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        -- ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = { "golang" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
EOF
endif
