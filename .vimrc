" $Id$
"
" set Options {{{
"--------------------------------------------------------------------------------
	set nocompatible                            " This isn't your Daddy's vi.
	syntax on                                   " turn on syntax highlighting
	set modeline                                " enable processing of modelines
	set modelines=1                             " either the first or last line is the modeline
	set t_Co=256                                " set 256 color mode always - it's 2014 already
	set ttyfast                                 " ttyfast indicates a fast terminal connection. force this.
	set background=dark                         " I'm always going to have a dark background
	set backspace=indent,eol,start              " Allow backspacing over everything in insert mode
	set tabstop=4                               " This is the tab key value.
	set noexpandtab                             " ASCII-9 chars when hitting tab
	set smarttab                                " use shiftwidth to calculate tabs
	set shiftwidth=4                            " This is the >> << value.
	set ruler                                   " Ruler looks cool.
	set autoindent                              " So useful.
	set autowrite                               " Save on any buffer change. Avoids crash loss
	set autowriteall
	set showmatch                               " Show me where the opening matches to closing ) } ] are.
	set showcmd                                 " Usefull for select and visual modes.
	set incsearch                               " incremental search
	set hlsearch                                " highlight search
	set ignorecase                              " Turn off ignorecase in a typed search if an uppercase char exists.
	set smartcase
	set nobackup                                " I hate *~ files.
	set noswapfile                              " adding to see if it helps with NFS problems
	set history=1000                            " Ex command history length
	set shm+=I                                  " No start up message
	set wrap                                    " let's display nicely, shall we?
	set splitbelow                              " more natural split locations
	set splitright
	set timeout timeoutlen=1000 ttimeoutlen=100 " remove delay when hitting o,O,etc..
	set backspace=2 whichwrap+=<,>,[,]          " backspace and cursor keys wrap to previous/next line
	filetype on                                 " Enable file type detection.
	set tags=./tags,~/.vim/tags                 " Tags
	set title                                   " changes xterm title automatically
	set list                                    " make nonprinting chars visible
	set listchars=tab:\│\ ,trail:·,nbsp:.,eol:↩ " set listchars=tab:>\.,trail:·,extends:»,precedes:«,nbsp:.,eol:¬
	set hidden                                  " remembers marks and undo when switching buffers
	set scrolloff=5                             " minimum number of lines above and below cursor
	set viminfo=<800,'10,/50,:100,h,f0,s10
	"           │    │   │   │    │ │  └ dunno, but this is the default. can't find documentation for it anywhere.
	"           │    │   │   │    │ └ file marks 0-9,A-Z 0=NOT stored
	"           │    │   │   │    └ disable 'hlsearch' loading viminfo
	"           │    │   │   └ command-line history saved
	"           │    │   └search history saved
	"           │    └ files marks saved
	"           └ lines saved each register (old name for <, vi6.2)
	"
	color gentooish                             " Color scheme

	" automatically wrap text to textwidth (t), automatically insert comment leader when inserting new lines (ro), autowrap comments to text width (c), better indentation of lists (n)
	set formatoptions+=trocn
	set isfname+=\	" IFS

	" DICTIONARY STUFF.
	if filereadable($VIM . "/words")
		set dictionary+=$VIM/words
	endif
	if filereadable("/usr/share/dict/words")
		set dictionary+=/usr/share/dict/words
	endif

	" better tab completion of hostnames - puts bar with names above
	set wildmenu
	set cpo-=<

	" set the 'cpoptions' to its Vim default
	let s:save_cpo = &cpoptions
	set cpo&vim

	" enable cursor line and column visual indicator
	if &diff
		color lodestone
		set nocursorline
		set nocursorcolumn
	else
		set cursorline
		set cursorcolumn
		set colorcolumn=+1
	endif"

	" UTF-8 by default
	if has("multi_byte")
		if &termencoding == ""
			let &termencoding = &encoding
		endif
		set encoding=utf-8
		setglobal fileencoding=utf-8
		"setglobal bomb
		set fileencodings=utf-8,latin1
	endif

	" fix delete
	if &term == "screen"
		set t_kb=
		fixdel
	endif

	"Status Line
	set statusline=%<\ %{mode()}\ \|\ %F%=\ %{&fileformat}\ \|\ %{&fileencoding}\ \|\ %{&filetype}\ \|\ %p%%\ \|\ LN\ %l:%c\
	set laststatus=2 " always show the status line
	set showmode
"--------------------------------------------------------------------------------
	" change cursor shape in insert mode -
	" this only works in xterm and iterm currently --2014-05-07
	" http://vim.wikia.com/wiki/Configuring_the_cursor
	" 1 or 0 -> blinking block
	" 2 solid block
	" 3 -> blinking underscore
	" 4 solid underscore
	" Recent versions of xterm (282 or above) also support
	" 5 -> blinking vertical bar
	" 6 -> solid vertical bar
	" solid underscore seems to work in xterm more frequently than blinking
	" vertical bar
	let &t_SI .= "\<Esc>[3 q"
	let &t_EI .= "\<Esc>[0 q"
"--------------------------------------------------------------------------------
" }}}
"
" Mappings/Remappings {{{
"--------------------------------------------------------------------------------
	" reformat paragraphs
	nnoremap Q gwip

	" move up and down by display lines, not actual lines.
	nnoremap k gk
	nnoremap j gj
	nnoremap gk k
	nnoremap gj j

	" maps esc to jj in insert mode.
	imap jj <ESC>

	" make Y behave like D and C
	nnoremap Y y$

	" Mappings For Comments
	map <F2> <ESC>:'<,'>s/^/# /g<ENTER>
	map <S-F2> <ESC>:'<,'>s/^# //g<ENTER>

	" backspace in Visual mode deletes selection
	vnoremap <BS> d

	" CTRL-X and SHIFT-Del are Cut
	vnoremap <C-X> "+x
	vnoremap <S-Del> "+x

	" CTRL-C and CTRL-Insert are Copy
"	vnoremap <C-C> "+y
	vnoremap <C-Insert> "+y

	" CTRL-V and SHIFT-Insert are Paste
"	map <C-V>	 "+gP
	map <S-Insert>	"+gP
"	cmap <C-V>	<C-R>+
	cmap <S-Insert>	 <C-R>+

	" Pasting blockwise and linewise selections is not possible in Insert and
	" Visual mode without the +virtualedit feature.	They are pasted as if they
	" were characterwise instead.
	if has("virtualedit")
		nnoremap <silent> <SID>Paste :call <SID>Paste()<CR>
		func! <SID>Paste()
			let ove = &ve
			set ve=all
			normal `^"+gPi^[
			let &ve = ove
		endfunc
		imap <C-V>	<Esc><SID>Pastegi
		vmap <C-V>	"-c<Esc><SID>Paste
	else
		nnoremap <silent> <SID>Paste "=@+.'xy'<CR>gPFx"_2x
		imap <C-V>	x<Esc><SID>Paste"_s
		vmap <C-V>	"-c<Esc>gix<Esc><SID>Paste"_x
	endif
	imap <S-Insert>		 <C-V>
	vmap <S-Insert>		 <C-V>

	" Use CTRL-B to do what CTRL-V used to do (block select)
"	noremap <C-B>	 <C-V>


	" forget to sudo? :w!!
	cmap w!! w !sudo tee % >/dev/null

	" move the cursor back to where it was after repeating a change
	nmap . .`[

	" automatically move cursor to end of pasted text
	vnoremap <silent> y y`]
	vnoremap <silent> p p`]
	nnoremap <silent> p p`]

	" remap ` to '	for easier jumping to marks
	"	nnoremap ' `
	"	nnoremap ` '

	" make left and right arrow keys do indentation in normal mode
	noremap <left> <<
	noremap <right> >>

	" center search results!
	nmap n nzz
	nmap N Nzz
"--------------------------------------------------------------------------------
" mappings for whitespace correction

	" remove trailing/leading whitespace
	nnoremap <silent> Ds :%s/\s\+$//<CR>
	nnoremap <silent> DS :%s/^\s\+//<CR>

	" remove whitespace which occurs prior to a tab character \t
	:nnoremap <silent> yt :%s/ \+\ze\t//g<CR>

	" remove paste artifacts from panes within tmux after selecting with the mouse
	:nnoremap <silent> yx :%s/\s\+x$//<CR>
"--------------------------------------------------------------------------------
" Leader mappings
" can't map leader to space, since that breaks pasting any text that contains spaces and then the pastetoggle character.

" change the mapleader from \ to ,
	let mapleader=","
"
" pasting with listchars on gets tedious.  let's fix that.
	nnoremap <silent> <Leader>lc :%s/>\.\+/	/g<CR>:%s/\s\+$//<CR>
" set paste
	set pastetoggle=<Leader>p

" toggle cursor line and column marker
	noremap <Leader>' :set cursorline!<CR> :set cursorcolumn!<CR>

" clear search highlights
	noremap <leader><space> :noh<cr>

" Align text
	nnoremap <leader>Al :left<cr>
	nnoremap <leader>Ac :center<cr>
	nnoremap <leader>Ar :right<cr>
	vnoremap <leader>Al :left<cr>
	vnoremap <leader>Ac :center<cr>
	vnoremap <leader>Ar :right<cr>

" Tabularize mappings
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a" :Tabularize /"<CR>
	vmap <Leader>a" :Tabularize /"<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
	nmap <Leader>a, :Tabularize /,\zs<CR>
	vmap <Leader>a- :Tabularize /-\zs<CR>
	nmap <Leader>a- :Tabularize /-\zs<CR>
	vmap <Leader>a, :Tabularize /,\zs<CR>

" toggle listchars
	nnoremap <Leader>l :set list!<CR><C-L>
"--------------------------------------------------------------------------------
" }}}
"
" Plugin/Explicit sourcings {{{
"--------------------------------------------------------------------------------
	runtime macros/matchit.vim        " better % matching
"	:source $HOME/.vim/plugin/rcs.vim " RCS plugin

" source any hostname-specific items
function! LoadFileNoError(filename)
	let FILE=expand(a:filename)
	if filereadable(FILE)
		exe  "source "  FILE
	endif
endfunction
let HOST = substitute ( hostname(), '\..*$', '', 'g' )
exec LoadFileNoError( "~/.vimrc." . HOST )

"--------------------------------------------------------------------------------
" vundle - auto install/update of plugins from github
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	Plugin 'gmarik/vundle'
"--------------------------------------------------------------------------------
"                               Plugins
"--------------------------------------------------------------------------------
" Look/Feel Plugins
	Plugin 'bling/vim-airline'                    " improved status line for vim
	Plugin 'bling/vim-bufferline'                 " show the list of buffers in the command bar
	Plugin 'nathanaelkane/vim-indent-guides'      " vim-indent-guides
"--------------------------------------------------------------------------------
"Color Schemes
	Plugin 'jonathanfilip/vim-lucius'             " lucius color scheme
	Plugin 'nanotech/jellybeans.vim'              " jellybeans color scheme
	Plugin 'briancarper/gentooish.vim'            " gentooish
"--------------------------------------------------------------------------------
" Feature enhancements / Addons
	Plugin 'godlygeek/tabular'                    " easily text alignment
	Plugin 'jamessan/vim-gnupg'                   " editing gpg-encrypted files
	Plugin 'luochen1990/rainbow'                  " better highlighting for nested {[()]}
	Plugin 'reedes/vim-litecorrect'               " vim-litecorrect - autocorrect
	Plugin 'Shougo/neocomplcache.vim'             " tab completion
	Plugin 'tpope/vim-abolish'                    " Easier abbreviations
	Plugin 'tpope/vim-commentary.git'             " comment things out easily
	Plugin 'tpope/vim-speeddating'                " Easy increment/decrement of dates/times
	Plugin 'tpope/vim-surround'                   " Easily surround text objects with '{[( etc
	Plugin 'tpope/vim-repeat'                     " Easily repeat with . plugin-based actions
	Plugin 'vim-scripts/Vitality'                 " fix vim autosave when inside tmux
	Plugin 'vimwiki/vimwiki'                      " vimwiki
"--------------------------------------------------------------------------------
" Syntax file additions
	Plugin 'tejr/vim-tmux'                        " tmux syntax
	Plugin 'chase/vim-ansible-yaml'               " ansible syntax
"--------------------------------------------------------------------------------
" Revision control enhancements
	Plugin 'ludovicchabant/vim-lawrencium'        " vim mercurial integration
	Plugin 'mhinz/vim-signify'                    " marks changed lines of revision controlled files
	Plugin 'tpope/vim-fugitive'                   " vim git integration
"--------------------------------------------------------------------------------
"                       Disabled Plugin
"	Plugin 'smancill/conky-syntax.vim'            " conkyrc syntax files
"	Plugin 'rodjek/vim-puppet'                    " puppet things
"	Plugin 'farseer90718/vim-taskwarrior'         " vim-taskwarrior
"	Plugin 'tangledhelix/vim-kickstart'           " syntax highlighting for kickstart files
"	Plugin 'vim-scripts/Xoria256m'                " color scheme
"	Plugin 'stantona/vim-tomorrow-night-theme'    " Color scheme
"	Plugin 'mivok/vimtodo'                        " syntax highlighting for todo.txt
"--------------------------------------------------------------------------------
" }}}
"
" Functions {{{
"--------------------------------------------------------------------------------
" Generates a frequency table of all words in the buffer or selection
" http://vim.wikia.com/wiki/VimTip1531
function! WordFrequency() range
	let all = split(join(getline(a:firstline, a:lastline)), '\A\+')
	let frequencies = {}
	for word in all
		let frequencies[word] = get(frequencies, word, 0) + 1
	endfor
	new
	setlocal buftype=nofile bufhidden=hide noswapfile tabstop=20
	for [key,value] in items(frequencies)
		call append('$', key."\t".value)
	endfor
	sort! in
endfunction
command! -range=% WordFrequency <line1>,<line2>call WordFrequency()
"
"--------------------------------------------------------------------------------
" }}}
"
" Autocommands {{{
"--------------------------------------------------------------------------------
if has("autocmd")
	filetype plugin indent on                       " load indent files, to automatically do language-dependent indenting.

	augroup markdown
		autocmd!
		autocmd BufNewFile,BufRead *.md set ft=markdown " fix problem detecting markdown files
	augroup END

	augroup linenumbers
		autocmd!
		autocmd FileType xml,html,c,cs,java,perl,shell,bash,cpp,python,vim,php,blog,make set number	" Line Numbers
	augroup END

" restore cursor to previous position when opening file
	function! ResCur()
		if line("'\"") <= line("$")
			normal! g`"
			normal! zz
			return 1
		endif
	endfunction

	augroup resCur
		autocmd!
		autocmd BufWinEnter * call ResCur()
	augroup END
"----------------------------------------------------------------------------

"----------------------------------------------------------------------------
" email editing
"----------------------------------------------------------------------------
	let g:mail_erase_quoted_sig=1                        " removes quoted signatures automagically (via mail.vim ftplugin)
	let g:mail_delete_empty_quoted=1                     " removed empty quoted lines
	autocmd FileType mail setlocal spell spelllang=en_us " spell checking!
"----------------------------------------------------------------------------
function! MailClean()
" HACK HACK HACK regexex abound and Herein Be Dragons HACK HACK HACK

	" fix collapsed >> back to > > which is more common
	silent! exec "normal :%s/>>/> >/ge"

	" delete any line that is quoted > > or more
	silent! exec "normal! :%g/^>\\s*>/de\<CR>"

	" Sent from my LATEST NOISY APP ATTRIBUTION!
	silent! exec "normal! :g/^>\\=\\s*Sent from my/de\<CR>"

	" occasionally we get orphaned attribution lines (linebreaks, etc.) the
	" next two lines clean those up
	" silent! exec "normal! :g/^> On \\(Mon,\\|Tue,\\|Wed,\\|Thu,\\|Fri,\\|Sat,\\|Sun,\\).*$/de\<CR>"
	" silent! exec "normal! :g/^> wrote:.*$/de\<CR>"

	" delete any two or more empty quoted lines
	silent! exec "normal! :g/\\(^>\\s*\\n\\)\\{2,}/de\<CR>"

	" delete empty line in middle of quoted lines
	silent! exec "normal! :g/^\\s*\\n>/de\<CR>"

	" delete empty quoted line followed by empty lines
	silent! exec "normal! :g/^>\\s*\\n\\n/de\<CR>"

	" delete two or more empty lines
	silent! exec "normal! :%s/\\n\\{3,}/\\r\\r/e\<CR>"

	" move cursor and insert new blank line
	silent! exec "normal! G?^>\<CR>:noh\<CR>o\<CR>"

	" end in insert mode please
	" startinsert
endfunction
" autocmd FileType mail call MailClean()
"----------------------------------------------------------------------------
" autoformat text and no autoformatting comment insertion when writing email.
	augroup email
		autocmd!
		autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
		autocmd FileType mail set fo=tcrqaw tw=72 autoindent expandtab encoding=utf-8

		" select crap to delete/summarize with [...] and hit D to do so
		autocmd FileType mail vmap D dO> [...]<CR><BS><BS>

		" removes nested quotes, empty quoted lines, and any section of two or more blank lines
		autocmd FileType mail map \f :call MailClean()<CR>
		autocmd FileType mail map \g :%g/^> >/d<CR>:%s/^>\s\+$/ /g<CR>:%s/\s\+$//e<CR>:%s/\n\{3,}/\r\r/e<CR>:g/^> \(On\\|At\)\(Mon,\\|Tue,\\|Wed,\\|Thu,\\|Fri,\\|Sat,\\|Sun,\).*$/d<CR>/>.*Original Message<CR>dGxo<BS>--<Esc>:r ~/.signature<CR>ggG?^><CR>:noh<CR>o<CR><CR><BS>

		"	highlight all lines past a certain point  ***FIXME*** figure out a way to automatically set OverLength to textwidth
		autocmd FileType mail highlight OverLength ctermbg=202 guibg=#2d2d2d guifg=#000 ctermfg=white
		autocmd FileType mail match OverLength /\%>72v/
	augroup END

"	autocmd FileType mail set listchars=tab:>\.,trail:·,extends:»,precedes:«,nbsp:.,eol:¬
"	autocmd Filetype mail set comments=nb:>
"----------------------------------------------------------------------------

"----------------------------------------------------------------------------
" Unusued autocommands
"----------------------------------------------------------------------------
"	automatically give executable permissions if filename is *.sh
"		autocmd BufWritePost *.sh :!chmod a+x <afile>
"
"	automatically post blog entries - this could get annoying.	I should simply map a function to call blog.pl on the current buffer
"		autocmd BufWritePost *.blog :!blog.pl "<afile>"
"
"	automatically give executable permissions if file begins with #!/bin/sh
"		autocmd BufWritePost * if getline(1) =~ "^#!/bin/[a-z]*sh" silent !chmod a+x <afile> endif
"
"		set file type to make for shc files
"		autocmd BufNewFile,BufRead *.shc setf make
endif
"--------------------------------------------------------------------------------
" }}}
"
" Highlighting overrides {{{
"--------------------------------------------------------------------------------
	"	Black background please
	"	hi Normal			guibg=#000000	ctermbg=232
	"	my preferred comment highlighting
	"	hi	Comment			guifg=#808080	guibg=#2d2d2d	gui=italic	ctermfg=237		ctermbg=232		cterm=italic
	"  listchars highlighting
	hi	SpecialKey		guifg=#666666	guibg=#151515	gui=none	ctermfg=235		ctermbg=232
	hi	NonText			guifg=#808080	guibg=#090909	gui=none	ctermfg=235		ctermbg=232
	" make search terms underlined in the gui, yellow background
	hi	Search			guibg=#CCCC00	guifg=#000000	gui=none	ctermfg=232		ctermbg=190		cterm=bold
	" set colorcolumn/cursorline/cursorcolumn highlighting
	hi	ColorColumn		guibg=#2d2d2d	ctermbg=234
	hi	CursorColumn	guibg=#2d2d2d	ctermbg=234
	hi	CursorLine		guibg=#2d2d2d	ctermbg=234
	" folds
	hi	Folded			guibg=#2d2d2d	guifg=#999	gui=none	ctermbg=234		ctermfg=244
	hi	FoldColumn		guibg=#2d2d2d	guifg=#999	gui=none	ctermbg=234		ctermfg=244

"--------------------------------------------------------------------------------
" }}}
"
" Plugin-specific items {{{
"--------------------------------------------------------------------------------
	" remap C-A/C-X (increment/decrement value under cursor by 1)
	"	noremap + <C-A>
	"	noremap - <C-X>
	nmap + <Plug>SpeedDatingUp
	nmap - <Plug>SpeedDatingDown
	xmap + <Plug>SpeedDatingUp
	xmap - <Plug>SpeedDatingDown
	nmap d+ <Plug>SpeedDatingNowUTC
	nmap d- <Plug>SpeedDatingNowLocal
"--------------------------------------------------------------------------------
	" rainbow parentheses
	" let g:rainbow_active = 1
"--------------------------------------------------------------------------------
	" vim-bufferline settings
	let g:bufferline_echo = 0
	autocmd VimEnter *
	\ let &statusline='%{bufferline#refresh_status()}'
	\ .bufferline#get_status_string()
"	let g:bufferline_inactive_highlight = 'StatusLine'
"	let g:bufferline_active_highlight = 'StatusLineNC'
	let g:bufferline_solo_highlight = 1
	let g:bufferline_active_buffer_left = '['
	let g:bufferline_active_buffer_right = ']'
	let g:bufferline_modified = '+'
	let g:bufferline_show_bufnr = 1
"--------------------------------------------------------------------------------
	" airline settings
	" use powerline symbols
	let g:airline_powerline_fonts = 1
	" airline theme
	let g:airline_theme='hybridline'
	let g:airline_detect_modified=1
	let g:airline_detect_paste=1
	let g:airline_detect_iminsert=1
	let g:airline#extensions#branch#enabled = 1
	" change the text for when no branch is detected
	let g:airline#extensions#branch#empty_message = ''
	" truncate long branch names to a fixed length
	let g:airline#extensions#branch#displayed_head_limit = 16
	" enable/disable syntastic integration
	let g:airline#extensions#syntastic#enabled = 1
"--------------------------------------------------------------------------------
	" when calling vimpager, disable X11
	let vimpager_disable_x11 = 1
	let vimpager_scrolloff = 10
"--------------------------------------------------------------------------------
"	" neocomplcache
	"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
	" Disable AutoComplPop.
	let g:acp_enableAtStartup = 0
	" Use neocomplcache.
	let g:neocomplcache_enable_at_startup = 1
	" Use smartcase.
	let g:neocomplcache_enable_smart_case = 1
	" Set minimum syntax keyword length.
	let g:neocomplcache_min_syntax_length = 3
	" AutoComplPop like behavior.
	let g:neocomplcache_enable_auto_select = 1
	" <TAB>: completion.
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
	inoremap <expr><C-y>  neocomplcache#close_popup()
	inoremap <expr><C-e>  neocomplcache#cancel_popup()
"--------------------------------------------------------------------------------
"	vim-signify
	let g:signify_vcs_list = [ 'hg', 'svn', 'git', 'rcs' ]
	let g:signify_line_highlight = 0
	let g:signify_sign_delete    = '-'
	"
"--------------------------------------------------------------------------------
"	vim-indent-guides
	let g:indent_guides_enable_on_vim_startup = 1
	let g:indent_guides_auto_colors = 0
	augroup indent-guides
		autocmd!
		autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black   ctermbg=232
		autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=235
	augroup END
"--------------------------------------------------------------------------------
" litecorrect
	augroup litecorrect
		autocmd!
		autocmd FileType markdown,mkd call litecorrect#init()
		autocmd FileType textile call litecorrect#init()
		autocmd FileType mail call litecorrect#init()
	augroup END
"--------------------------------------------------------------------------------
" vim ansible
	let g:ansible_options = {'ignore_blank_lines': 0}
	augroup ansible
		autocmd!
		autocmd BufEnter *.yml :set ft=ansible
	augroup END
"--------------------------------------------------------------------------------
" }}}
"
" Abbreviations {{{
"--------------------------------------------------------------------------------
	ab XA X-Attachment: none
	ab DATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
	ab TD <C-R>=strftime("%Y-%m-%d")<CR>
	ab br <br />
" Fix common tyops {{{
"--------------------------------------------------------------------------------
if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif"
"--------------------------------------------------------------------------------
" }}}
"
" experimental stuff {{{
"--------------------------------------------------------------------------------
	cnoremap q1 q!

" }}}
"
" vim:foldmethod=marker:foldlevel=1:colorcolumn=0:nowrap
