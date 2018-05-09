" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
set nocompatible

" set g:os to either Windows, Linux or Darwin
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

" pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

if g:os == "Windows"
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin

  set diffexpr=MyDiff()
  function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        let cmd = '""' . $VIMRUNTIME . '\diff"'
        let eq = '"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
      let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  endfunction

	if has("autocmd")
		au GUIEnter * simalt ~x
	endif

	set encoding=cp936
endif

" Configuration {
	set nocp
	set ts=4	"tab stop
	set sw=4	"shift width
	set smarttab
	set incsearch	"do incremental search
	set hlsearch	"highlight matched text when searching
	"set ignorecase
	set number	"enable line number
	set wrap
	syntax enable
	syntax on
	let mapleader = ","
	set shellpipe=2>&1\|\ tee
	set smartcase
	set whichwrap+=h,l
	set mouse=a
	set colorcolumn=80
    " https://stackoverflow.com/a/11421329
    if $TMUX == ''
        set clipboard=unnamed
    endif
	" set encoding
	set fileencodings=utf-8,gb2312
	"set foldmethod
	set foldlevel=1000
	" Enable file type detection
	filetype plugin indent on

    " Session {
        set sessionoptions=buffers
    " }

	" GUI {
		if ! has("gui_running")
			set t_Co=256
            let g:solarized_termcolors=256
        else
			" with bottom scroll bar
			set guioptions+=b
			" with right-hannd scroll bar
			set guioptions-=r

			map <F11> :call TweakGUI()<cr>

            if g:os == "Windows"
                set guifont=Consolas:h11:cANSI
            endif

		endif
	" }

	" color scheme {
		set background=dark
		" colors solarized
		colors gruvbox
	" }
	"
	" Disable preview window of completion
	set completeopt=longest,menu

	" Search for selected words in visual mode
	nnoremap <leader>s :%s/\<<C-r><C-w>\>/

" }
"
" Key mappings {

	nnoremap <CR> :nohlsearch<CR><CR>
	" alternate buffer
	noremap <Leader><Leader> <C-^>
	" select all text in current buffer
	map <Leader>a ggVG
    " Window resizing {
    "http://vim.wikia.com/wiki/Resize_splits_more_quickly
    " basic key maps: Ctrl-w +-<>_|
    " resize by steps: Ctrl-w 10 +
    " maximize: Crl-w |
        nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
        nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
        nnoremap <silent> <Leader>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
        nnoremap <silent> <Leader>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
    " }

	" Better command mode editing {
		" down arrow
		cnoremap <C-j> <t_kd>
		" up arrow
		cnoremap <C-k> <t_ku>
		cnoremap <C-a> <Home>
		cnoremap <C-e> <End>
	" }
	"
	" Remove all trailing white-space characters
	nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
	" Retab and Format the File with Spaces
	nnoremap <leader>T :set expandtab<cr>:retab!<cr>
	" Highlight word at cursor without changing position
	nnoremap <leader>h *<C-O>
	" Find
	nmap <leader>f [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " Copy current buffer file path to system clipboard
    nmap <leader>% :let @+ = expand("%")<CR>
    " Open dir of current file: http://vimcasts.org/episodes/the-edit-command/
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

	" Window Switching {
		map <C-j> <C-W>j
		map <C-k> <C-W>k
		map <C-h> <C-W>h
		map <C-l> <C-W>l
	" }

	" Yank/paste {
		nmap <leader>y "by
		nmap <leader>p "bp
		vmap <leader>y "by
		vmap <leader>p "bp
		vmap <C-a>     "+y
		nnoremap <C-a> "+p
	" }
	
	" Buffer management {
		map <F2> <ESC>:buffer!
		map <M-y> <ESC>:buffer!
		map <leader>bb <ESC>:buffer!
		"S-F2 key doesn't work in terminal, use :BD instead"
		map <S-F2> <ESC>:call DeleteCurrentBuffer()<CR>
		map <F3> <ESC>:bp!<CR>
		map <F4> <ESC>:bn!<CR>
		map <M-u> <ESC>:bp!<CR>
		map <M-i> <ESC>:bn!<CR>
		map <leader>bq <ESC>:bp!<CR>
		map <leader>bw <ESC>:bn!<CR>
		if !has("gui_running")
			map <F9> <ESC>:bp!<CR>
			map <F10> <ESC>:bn!<CR>
		endif
		command -nargs=0 BD :silent call DeleteCurrentBuffer()
	" }

	" Quick editting of vim configurations {
    if g:os == "Windows"
		nmap <silent> <leader>vs :source ~/_vimrc<cr>
		nmap <silent> <leader>ve :e ~/_vimrc<cr>
    else
		nmap <silent> <leader>vs :source ~/.vimrc<cr>
		nmap <silent> <leader>ve :e ~/.vimrc<cr>
    endif
    nmap <silent> <leader>ce :e ~/.vim/snippets/cpp.snippets<cr>
	" }

	" Omini complete {
		inoremap <C-F>             <C-X><C-F>
		inoremap <C-D>             <C-X><C-D>
		inoremap <C-L>             <C-X><C-L>
	" }

	" Quickfix {
		" Automatically open, but do not go to (if there are errors) the quickfix /
		" location list window, or close it when is has become empty.
		"
		" Note: Must allow nesting of autocmds to enable any customizations for quickfix
		" buffers.
		" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
		" (but not if it's already open). However, as part of the autocmd, this doesn't
		" seem to happen.
		autocmd QuickFixCmdPost [^l]* nested cwindow
		autocmd QuickFixCmdPost    l* nested lwindow

		nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
		nmap <leader>cn :cn<cr>
		nmap <leader>cp :cp<cr>
		nmap <leader>cl :clist<cr>
		" press v in quickfix window to preview
		au FileType qf :nnoremap <buffer> v <Enter>zz:wincmd p<Enter>
	" }
" }

" Filetype {
	" Detect filetype {
		augroup filetypedetect
			au BufRead,BufNewFile *.todo setfiletype todo
			" use "set ft=` for Makefile as we have a Makefile.sth we will be set in
			" /usr/share/vim/vim73/filetype.vim
			" setfiletype will not set the filetype if it has already been set elsewhere.
			au BufRead,BufNewFile Makefile.* set ft=make
			au BufRead,BufNewFile *.txt setfiletype txt
		augroup END
	" }
    " skip quickfix in buflist. help 'buflisted'
    augroup qf
        autocmd!
        autocmd FileType qf set nobuflisted
    augroup END

	" Work Enviroment setup {
		if has("autocmd")
			au FileType python call s:SetPythonEnv()
			au FileType tex call s:SetTexEnv()
			au FileType cpp,c call s:SetCEnv()
			au FileType java call s:SetJavaEnv()
			au FileType mp call s:SetMetapostEnv()
			au FileType mkd call s:SetMarkDownEnv()
		endif
	" }

	" Auto-generates file heading
	autocmd BufNewFile *.hpp,*.h,*.hh call AddCHeaderDefine()
	autocmd BufNewFile *.py call AddHexPreamble()

	" Other auto commands
	"autocmd InsertLeave *.py,*.hpp,*.cc,*.c,*.h write " autosave
	"autocmd InsertLeave *.hpp,*.cc,*.c,*.h TlistUpdate "Update tags

" }

if g:os=="Darwin"
	map <D-0> :w<CR>
	map <D-9> :set foldlevel=1000<CR>
	map <D-8> :set nowrap!<CR>
	map <D-7> :CDP<CR>
	nmap <D-j> <C-d>
	nmap <D-k> <C-u>
	map <D-u> <ESC>:bp!<CR>
	map <D-i> <ESC>:bn!<CR>
	inoremap <D-j> <ESC>
	if has('gui_macvim')
		" try :h gestures in MacVim
		nnoremap <silent> <SwipeLeft> :bN<CR>
		nnoremap <silent> <SwipeRight> :bn<CR>
		set macmeta
	endif
else
	map <M-0> :w<CR>
	map <M-9> :set foldlevel=1000<CR>
	map <M-8> :set nowrap!<CR>
	map <M-7> :CDP<CR>
	nmap <M-j> <C-d>
	nmap <M-k> <C-u>
	inoremap <M-j> <ESC>
endif

if !exists(':CDP')
	command -nargs=0 CDP :silent call ChangeCurrDir()
endif

" Plugins {
	" MRU {
		nnoremap <leader>ru :MRU<CR>
	" }

	" Taglist {
		"let Tlist_Show_One_File=1
		let Tlist_Exit_OnlyWindow=1
		let Tlist_Use_Right_Window=1
		let Tlist_File_Fold_Auto_Close=1
		nmap <leader>tg :TlistToggle<cr>
	" }

	" WinManager {
		let g:winManagerWindowLayout='FileExplorer'
		"let g:winManagerWindowLayout='FileExplorer,TagList|WKSpaceExplorer'
		"let g:winManagerWindowLayout='FileExplorer|TagList'
		"let g:winManagerWindowLayout='WKSpaceExplorer|TagList'
		nmap <leader>wm :WMToggle<cr>
		nmap <leader>wt :call SwitchWinmanagerAndTlist()<cr>
		func SwitchWinmanagerAndTlist()
			if IsWinManagerVisible()
				WMClose
				TlistOpen
			else
				TlistClose
				WManager
			endif
		endfunc
	" }
    "
    " { NERDTree
        map <leader>nn :NERDTreeToggle<CR>
        " find the current buffer in nerd tree
        map <leader>nf :NERDTreeFind<cr>
        " close vim if only NERDTree window
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        let NERDTreeWinSize=60
    " }

	" UltiSnips {
		" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
		let g:UltiSnipsExpandTrigger="<tab>"
		let g:UltiSnipsJumpForwardTrigger="<c-b>"
		let g:UltiSnipsJumpBackwardTrigger="<c-z>"
	" }

	" a.vim {
		let g:alternateNoDefaultAlternate = 1
        let g:alternateExtensions_ipp = "inc,h,H,HPP,hpp"
        let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,ipp"
	" }

	" CScope & tags settings {
		"set cscopequickfix=s-,c-,d-,i-,t-,e-
		if has("cscope")
			set csto=1
			set cst
			set nocsverb
			" add any database in current directory
			if filereadable("cscope.out")
				cs add cscope.out
			endif
			set csverb

			nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
			nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
			nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
			nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
			nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
			nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
			nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
			nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
		endif

		map <C-F12> :!ctags -R --c++-kinds=+p --fields=+ialS --extra=+q
		map <S-F12> :!cscope -b <CR>

		func SetTags()
			set tags=./tags,tags

			if g:os=="Linux"
				set tags+=/home/wangdq/tags/systags
				if filereadable("../tags")
					set tags+=../tags
				endif
			endif
		endfunc
		call SetTags()
	" }

	" MiniBufExplorerlet g:miniBufExplMapWindowNavVim = 1
	map <Leader>bt :TMiniBufExplorer<cr>
	"let g:miniBufExplMapWindowNavArrows = 1

	" ctrlp {
		let g:ctrlp_map = '<C-p>'
        if g:os == "Windows"
            set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*,*\\build\\**,*\\opt\\googletest\\**  " Windows ('noshellslash')
        else
            set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/build/        " Linux/MacOSX
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/]build$',
                \ 'file': '\v\.(exe|so|dll)$',
                \ }
        endif
        nmap <leader>tf :CtrlP<CR>
        nmap <leader>tb :CtrlPBuffer<CR>
        nmap <leader>tm :CtrlPMRU<CR>
        " this one is frequently used. Give it a shortcut
        " NOTE: cannot use <C-M>. It's equivalent to <CR>
        nmap <tab> :CtrlPMRU<CR>
		let g:ctrlp_working_path_mode = 'a'
	" }

	" showmarks {
		" Enable ShowMarks
		let showmarks_enable = 1
		" Show which marks
		let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		" Ignore help, quickfix, non-modifiable buffers
		let showmarks_ignore_type = "hqm"
		" Hilight lower & upper marks
		let showmarks_hlline_lower = 1
		let showmarks_hlline_upper = 1
		" Hilight color
		"hi ShowMarksHLl ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
		"hi ShowMarksHLu ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
	" }

	" markbrowser {
		nmap <silent> <leader>mk :MarksBrowser<cr>
	" }

	" NERD_Commenter.vim {
		"let g:NERDMapleader=',n'
		"let g:NERDShutUp=1
	" }

	" previewtag {
		" make the preview window not appear with vim start
		"let g:Preview_Window_Open = 1
		" make you could press F5 key to open or close the preview window, you can also set to other favorite hotkey here
		func s:SetPtagMaps()
			map <F5> :PshowORdelete<CR>
			map <S-F5> :Pdelete<CR>
			map <C-F5> :pclose<CR>
			map <F6> :Pswitch<CR>
		endfunc
	" }
	
	" autocomplpop {
		nmap <leader>ace :AcpEnable<cr>
		nmap <leader>acd :AcpDisable<cr>
        " nmap <leader>ste :call s:EnableSupertab()<cr>

		" default: diable supertab and use acp
		let g:loaded_supertab = 1
		" to avoid loading supertab.vim multiple times
		let g:enabled_supertab = 0
		" diable acpand use supertab
		function! s:EnableSupertab()
			if g:enabled_supertab==0
				AcpDisable
				let g:loaded_supertab = 0
				let g:enabled_supertab = 1
				source ~/.vim/plugin/supertab.vim
			endif
		endfunction

	" }
	" fugitive {
        nnoremap <leader>ga :Git add %:p<CR><CR>
        nnoremap <leader>gs :Gstatus<CR>
        nnoremap <leader>gt :Gcommit -v -q %:p<CR>
        nnoremap <leader>gc :Gcommit -v -q<CR>
        nnoremap <leader>gd :Gdiff<CR>
        nnoremap <leader>gp :Gpush<CR>
    " }

" }

" Function & Commands {

	function ChangeCurrDir()
		let _dir = expand("%:p:h")
		exec "cd " . _dir
		unlet _dir
	endfunction

	func DeleteCurrentBuffer()
		let cw = bufnr("%")
		exe "bn"
		exe "bd " . cw
	endfunc
	
	let g:guiTweaked = 0
	if has("gui_running")
		function TweakGUI()
		  if g:guiTweaked == 0
			let g:guiTweaked = 1
			"simalt ~x
			if g:os != "Darwin"
				set go-=m
			endif
			set go-=T
			set go-=r
			set go-=b
		  else
			let g:guiTweaked = 0
			"simalt ~x
			set go+=m
			set go+=T
			set go+=r
			set go+=b
		  endif
		endfunction

		if g:os == "Darwin"
			call TweakGUI()
		endif
	endif

	" Set Working Environments {
		function s:SetPythonEnv()

		   set textwidth=0
			set expandtab " always convert tab to spaces
			set omnifunc=pythoncomplete#Complete
			" no auto complete when moving cursor in insert mode
			let g:acp_mappingDriven = 1

			"setting python-mode
			let g:pymode_doc_key = 'K'

			if g:os == "Windows"
				"source d:\vimfiles\python.vim
				set complete+=kd:\vimfiles\pydiction isk+=.,(
				map <F12> <ESC>:!"c:\Python25\python.exe" %<CR>
			elseif g:os == "Linux"
				"source ~/vimfiles/python.vim
				"set complete+=k~/vimfiles/pydiction isk+=.,(
				map <F12> <ESC>:!"python" %<CR>
			elseif g:os == "Darwin"
				"source ~/vimfiles/python.vim
				"set complete+=k~/vimfiles/pydiction isk+=.,(
				map <F12> <ESC>:!"python" %<CR>
			endif
			let g:py_select_leading_comments = 0
            " E501: line too lone
            " E722: base except
            let g:pymode_lint_ignore = "E501,E722"
		endfunction

		command! -nargs=0 -bar PythonWork call s:SetPythonEnv()

		function s:SetCEnv()
			" supertab
			"call s:EnableSupertab()
			let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
		  map <buffer> <leader><space> :make<cr>
		  map <buffer> <leader>d<space> :make DEBUG=1<cr>
			"call s:SetPtagMaps()
			set wrap
			set textwidth=0
			set expandtab
			set ts=4	"tab stop
			set sw=4	"shift width
            set cino=N-s "no indentation for namespace. :help cinoptions-values
			set errorformat^=%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file\ included\ from\ %f:%l:%c%m,
			"call s:LoadFlyMake()
		endfunction

		command! -nargs=0 -bar CWork call s:SetCEnv()

		function s:SetSingleCpp(debug)
			if a:debug
				let &makeprg="g++ -std=c++11 -Wall -g -O0 % -o " . expand("%:r")
			else
				let &makeprg="g++ -std=c++11 -Wall % -o " . expand("%:r")
			endif
			nnoremap <buffer> <leader>rr :exe '!\./'.expand("%:r")<cr>
		endfunction

		command! -nargs=0 -bar SingleCpp call s:SetSingleCpp(0)
		command! -nargs=0 -bar SingleCppDebug call s:SetSingleCpp(1)

		function s:SetJavaEnv()
			set wrap
			set textwidth=0
			set ts=4	
			set sw=4
			set expandtab
		endfunction

		func MarkDownHtml()
			let _htmlfile=expand("%:r") . '.html'
			exec "update"
			exec "!Markdown.pl % >"._htmlfile
		endfunc

		function s:SetMarkDownEnv()
			"map <buffer> <leader><space> :w<cr>:!make<cr>
			command! -nargs=0 -bar Mou :!open -a mou %
			"command! -nargs=0 -bar Mdpreview :!multimarkdown % | bcat
			nmap <leader>lp :!multimarkdown % \| bcat<cr>
			let &makeprg="Markdown.pl % >" . expand("%:r")
			map <buffer> <leader><space> :call MarkDownHtml()<cr>
			set textwidth=80
		endfunction

		" tex & latex edit
		func! ViewCompiledPdf()
			let _pdffile=expand("%:r") . ".pdf"
			if filereadable(_pdffile)
				if g:os=="Darwin"
					exec "!open " . _pdffile . "&"
				else
					exec "!evince " . _pdffile . "&"
				endif
			else
				echo "File doesn't exist: "._pdffile
			endif
		endfunc

		func BibTexPdf()
			let _currfile=expand("%:r")
			let _texfile=_currfile . '.tex'
			if filereadable(_texfile)
				exec "update"
				exec "!latex " . _currfile
				exec "!bibtex " . _currfile
				exec "!latex " . _currfile
				exec "!latex " . _currfile
				exec "!dvipdf " . _currfile
			else
				echo "File doesn't exist: " . _texfile
			endif
		endfunc

		func TexPdf()
			let _currfile=expand("%:r")
			let _texfile=_currfile . '.tex'
			if filereadable(_texfile)
				exec "update"
				exec "!latex " . _currfile
				exec "!dvipdf " . _currfile
			else
				echo "File doesn't exist: " . _texfile
			endif
		endfunc

		func LoadTexSuite()
			" For latex-suite
			" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
			" can be called correctly.
			set shellslash

			" IMPORTANT: grep will sometimes skip displaying the file name if you
			" search in a singe file. This will confuse latex-suite. Set your grep
			" program to alway generate a file-name.
			set grepprg=grep\ -nH\ $*

			if has('gui_running')
				imap <buffer> <silent> <C-k> <Plug>Tex_Completion
			else
				imap <buffer> <C-k> <Plug>Tex_Completion
			endif
		endfunc

		func s:SetTexEnv()
			call LoadTexSuite()

			set spell
			set textwidth=80

			call ChangeCurrDir()

			nmap <silent> <leader>lp :!pdflatex %<cr><cr>
			nmap <silent> <leader>lt :cal TexPdf()<cr><cr>
			nmap <silent> <leader>lf :call ViewCompiledPdf()<cr>
			nmap <silent> <leader>lb :call BibTexPdf()<cr>
			nmap <silent> <buffer> <leader><space> :w<cr>:make<cr>
		endfunc

		command! -nargs=0 -bar TexWork call s:SetTexEnv()
		" end of tex & latex edit

		" metapost
		func s:SetMetapostEnv()
			" texexec is about to be explored
			set nospell
			call ChangeCurrDir()
			nmap <silent> <leader>lm :!mptopdf %<cr>
		endfunc

		command! -nargs=0 -bar MpWork call s:SetMetapostEnv()
		" end of metapost
	" }

	" File preambles {

		func AddHexPreamble()

			call append(0, "\#!/usr/bin/env python")
			call append(1, "\# -*- coding: utf-8 -*-")
			call append(2, "")

		endfunc

		func AddCHeaderDefine()

			" Starting from line 11 since the Preamble ends at line 9."
            if g:os == "Windows"
                let s:lname = strpart(expand("%"),eval(1 + strridx(expand("%"), "\\")))
            else
                let s:lname = strpart(expand("%"),eval(1 + strridx(expand("%"), "/")))
            endif
			let s:label = toupper(substitute(s:lname, "\\.", "_", ""))."_"
			call append(0, "#ifndef ".s:label)
			call append(1, "#define ".s:label)
			call append(2, "")
			call append(3, "")
			call append(4, "")
			call append(5, "")
			call append(6, "#endif")

		endfunc

		func AddCPreamble()

			call append(0, "\/\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*")
			call append(1, " \* File       : ".strpart(expand("%"),eval(1 + strridx(expand("%"), "/"))))
			call append(2, " \* Author     : ".expand("$LOGNAME"))
			call append(3, " \* Copyright  : ")
			call append(4, " \* Description: TODO")
			call append(5, " \* Created    : ".strftime("%c"))
			call append(6, " \* Revision   : none")
			call append(7, " \*")
			call append(8, " \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\/")
			call append(9, " ")

		endfunc

	" }

" }
"
func! SourceLocalVimrc()
    if filereadable(glob("~/.vimrc.local")) 
        source ~/.vimrc.local
    endif
endfunc
call SourceLocalVimrc()
