" ============================================================================
" Active plugins
" You can disable or add new ones here:

" this needs to be here, so vim-plug knows we are declaring the plugins we
" want to use
call plug#begin('~/.config/nvim/plugged')

" Now the actual plugins:

" Override configs by directory
Plug 'arielrossanigo/dir-configs-override.vim'

" Code commenter
Plug 'scrooloose/nerdcommenter'

" Better fileviewer
Plug 'scrooloose/nerdtree'

" Git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Search results counter
Plug 'vim-scripts/IndexedSearch'

" Gruvbox theme
Plug 'sainnhe/gruvbox-material'

" Lightline
Plug 'itchyny/lightline.vim'
" Coc diagnostics indicator for lightline
Plug 'josa42/vim-lightline-coc'
" Bufferline
Plug 'mengelbrecht/lightline-bufferline'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Pending tasks list
Plug 'fisadev/FixedTaskList.vim'

" Intellisense engine with full language server protocol support as VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Automatically close parenthesis, etc
Plug 'Townk/vim-autoclose'

" Surround
Plug 'tpope/vim-surround'

" Indent text object
Plug 'michaeljsmith/vim-indent-object'

" Indentation based movements
Plug 'jeetsukumaran/vim-indentwise'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter'

" Paint css colors with the real color
Plug 'norcalli/nvim-colorizer.lua'

" Automatically sort python imports
Plug 'fisadev/vim-isort'

" Highlight matching html tags
Plug 'valloric/MatchTagAlways'

" Git integration
Plug 'tpope/vim-fugitive'

" VCS display changes on line numbers
Plug 'mhinz/vim-signify'

" Yank history navigation
Plug 'vim-scripts/YankRing.vim'

" Indent guides
Plug 'glepnir/indent-guides.nvim'

" Cmake integration
Plug 'cdelledonne/vim-cmake'

" Icons based on file extensions
Plug 'ryanoasis/vim-devicons'

" Tell vim-plug we finished declaring plugins, so it can load them
call plug#end()
" ============================================================================
" Vim settings and mappings
" You can edit them as you wish

" default update time of 4000ms (4s) is too slow for asynchronous tasks
set updatetime=100

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
set signcolumn=number

" change leader key to comma
let mapleader=","

" use mouse
set mouse=a

" tabs and spaces handling
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" show line numbers
set nu

" show ruler at 110 characters mark
set colorcolumn=110

" make '/' search case-insensitive but sensitive if search is all capitals
set ignorecase
set smartcase

" spellcheck on
set spelllang=en_us
set spellfile=~/.config/nvim/spell/en.utf-8.add
autocmd BufNewFile,BufRead *.md,*.txt,*.tex setlocal spell

" needed so deoplete can auto select the first suggestion
set completeopt+=noinsert
" comment this line to enable autocompletion preview window
" (displays documentation related to the selected completion option)
set completeopt-=preview

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" automatically use the system clipboard for copy and paste
set clipboard=unnamedplus

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" clear search results
nnoremap <silent> // :noh<CR>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" automate g++ Makefile compilation and execution
command Make !make; ./test; make clean

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
  if win_gotoid(g:term_win)
    hide
  else
    botright new
    exec "resize " . a:height
    try
      exec "buffer " . g:term_buf
    catch
      call termopen($SHELL, {"detach": 0})
      let g:term_buf = bufnr("")
      set nonumber
      set norelativenumber
      set signcolumn=no
    endtry
    startinsert!
    let g:term_win = win_getid()
  endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <F1> :call TermToggle(12)<CR>
tnoremap <F1> <C-\><C-n>:call TermToggle(12)<CR>

" Dynamically change background based on zsh env var
function! SetBackgroundMode(...)
  let s:new_bg = "light"
  let s:palette = "original"
  if $NVIM_BACKGROUND ==? "dark"
    let s:new_bg = "dark"
    let s:palette = "material"
  else
    let s:new_bg = "light"
    let s:palette = "original"

  endif
  if &background !=? s:new_bg
    let &background = s:new_bg
    let g:gruvbox_material_palette = s:palette
  endif
endfunction

call SetBackgroundMode()

" ============================================================================
" Plugins settings and mappings
" Edit them as you wish.

" Gruvbox Material -----------------------------

" Set background initially to dark
if has('termguicolors')
  set termguicolors
endif

" Set contrast.
let g:gruvbox_material_palette='original'
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material

" Colorizer
lua require'colorizer'.setup()

" NERDTree -----------------------------

" open nerdtree with the current file selected
nmap <F3> :NERDTreeFind<CR>
" don't show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.class$', '\.o$']
" no more ? for help
let NERDTreeMinimalUI=1
" automatically quit nerdtree after opening file
let NERDTreeQuitOnOpen=1
" nerdtree starts when file opens
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" close nerdtree if only it remains
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDCommenter ---------------------------
let g:NERDSpaceDelims = 1

" Tasklist ------------------------------

" show pending tasks list
map <F2> :TaskList<CR>

" Coc -----------------------------------------

" plugins
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-ccls',
  \ 'coc-java', 
  \ 'coc-pyright',
  \ ]

" eslint correction
nmap <F5> :CocCommand eslint.executeAutofix<CR>

" Treesitter ---------------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},  -- list of language that will be disabled
  },
}
EOF

" Indent Guides ------------------------------------
lua <<EOF
if (os.getenv('NVIM_BACKGROUND') == 'dark')
then
  fg = '#3C3836';
  bg = '#504946';
else
  fg = '#EBDBB2';
  bg = '#D5C4A1';
end

require('indent_guides').setup({
  indent_levels = 30;
  indent_guide_size = 1;
  indent_start_level = 1;
  indent_space_guides = true;
  indent_tab_guides = false;
  indent_soft_pattern = '\\s';
  exclude_filetypes = {'help', 'dashboard', 'dashpreview', 'NvimTree', 'vista', 'sagahover'};
  even_colors = {fg = fg, bg = bg};
  odd_colors = {fg = bg, bg = fg};
})
EOF

" Fzf ------------------------------

" file finder mapping
nmap <leader>f :Files<CR>
" general code finder in all files mapping
nmap <leader>r :Rg<CR>
" search under the cursor
nmap <leader>R :exec 'Rg' expand('<cword>')<CR>
" commands finder mapping
nmap <leader>c :Commands<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Customize fzf colors to match your color scheme
let g:fzf_colors = {
  \ 'fg': ['fg', 'Normal'],
  \ 'bg': ['bg', 'Normal'],
  \ 'hl': ['fg', 'Comment'],
  \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+': ['fg', 'Statement'],
  \ 'info': ['fg', 'PreProc'],
  \ 'border': ['fg', 'Ignore'],
  \ 'prompt': ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker': ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header': ['fg', 'Comment'], 
  \ }

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 90% of the height
  let height = float2nr(&lines * 0.9)
  " 60% of the height
  let width = float2nr(&columns * 0.6)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = 1

  let opts = {
  \ 'relative': 'editor',
  \ 'row': vertical,
  \ 'col': horizontal,
  \ 'width': width,
  \ 'height': height
  \ }

" open the new window, floating, and enter to it
call nvim_open_win(buf, v:true, opts)
endfunction

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:60%'), <bang>0)

" Ripgrep setting with preview window
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --block-buffered --color=always --fixed-strings --line-number --no-heading --smart-case --trim '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%'),
  \   <bang>0
  \ )

" Signify ------------------------------

" this first setting decides in which order try to guess your current vcs
" UPDATE it to reflect your preferences, it will speed up opening files
let g:signify_vcs_list = ['git', 'hg']
" mappings to jump to changed blocks
nnoremap <leader>gd :SignifyHunkDiff<cr>
nnoremap <leader>gu :SignifyHunkUndo<cr>

" nicer colors

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert
"  mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Yankring -------------------------------

" Fix for yankring and neovim problem when system has non-text things copied
" in clipboard
let g:yankring_clipboard_monitor = 0
let g:yankring_history_dir = '~/.config/nvim/'

" Vim-cmake ---------------------------------
let g:cmake_default_config = 'build'
let g:cmake_jump_on_completion = 1
let g:cmake_generate_options = [
  \ '-G Ninja',
  \ '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
  \ ]
let g:cmake_link_compile_commands = 1

" Lightline -------------------------------
set noshowmode

" register coc compoments
call lightline#coc#register()

" bufferline configs
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#composed_number_map = {
  \ 1:  '⑴ ', 2:  '⑵ ', 3:  '⑶ ', 4:  '⑷ ', 5:  '⑸ ',
  \ 6:  '⑹ ', 7:  '⑺ ', 8:  '⑻ ', 9:  '⑼ ', 10: '⑽ ',
  \ 11: '⑾ ', 12: '⑿ ', 13: '⒀ ', 14: '⒁ ', 15: '⒂ ',
  \ 16: '⒃ ', 17: '⒄ ', 18: '⒅ ', 19: '⒆ ', 20: '⒇ '}
let g:lightline#bufferline#clickable = 1

let g:lightline = {
  \ 'colorscheme' : 'gruvbox_material',
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste'],
  \     ['fugitive', 'readonly', 'filename', 'modified'],
  \     ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok'],
  \     ['coc_status'],
  \   ],
  \   'right': [
  \     ['lineinfo'],
  \     ['percent'],
  \     ['fileformat', 'fileencoding', 'filetype'],
  \   ],
  \ },
  \ 'tabline': {
  \   'left': [ ['buffers'] ],
  \   'right': [ ['close'] ],
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \   'filename': 'FilenameWithIcon',
  \   'filetype': 'LightlineFiletype',
  \   'fileformat': 'FileformatWithIcon',
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel',
  \ },
  \ 'component_raw': { 'buffers': 1 },
  \ }

function! LightlineFugitive()
  if exists('*FugitiveHead')
    return FugitiveHead()
  endif
  return ''
endfunction

function! FilenameWithIcon()
  return expand('%:t') !=# ''
  \ ? WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:t')
  \ : '[No Name]'
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? strlen(&filetype) ? &filetype : 'no ft' : ''
endfunction

function! FileformatWithIcon()
  return winwidth(0) > 70 ? &fileformat . ' ' . WebDevIconsGetFileFormatSymbol() : ''
endfunction
