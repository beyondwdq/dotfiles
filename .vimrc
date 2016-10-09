set nocompatible

" Function MySys()
"source $VIMRUNTIME/mysys.vim

function! MySys()
  return "macos"
endfunction

" pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

if MySys() == "windows"
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

" configuration
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
"set cul
"set cuc
set colorcolumn=80
set clipboard=unnamed

"set color scheme
if ! has("gui_running")
		set t_Co=256
endif
set background=dark
colors peaksea
"colors solarized

" Enable file type detection
filetype plugin indent on

augroup filetypedetect
    au BufRead,BufNewFile *.todo setfiletype todo
	" use "set ft=` for Makefile as we have a Makefile.sth we will be set in
	" /usr/share/vim/vim73/filetype.vim
	" setfiletype will not set the filetype if it has already been set elsewhere.
    au BufRead,BufNewFile Makefile.* set ft=make
	au BufRead,BufNewFile *.txt setfiletype txt
augroup END

if has("autocmd")
	au FileType python call s:SetPythonEnv()
	au FileType tex call s:SetTexEnv()
	au FileType cpp,c call s:SetCEnv()
	au FileType java call s:SetJavaEnv()
	au FileType mp call s:SetMetapostEnv()
	au FileType mkd call s:SetMarkDownEnv()
endif " has("autocmd")

" Auto-generates file heading
autocmd BufNewFile *.hpp,*.h,*.hh call AddCHeaderDefine()
autocmd BufNewFile *.py call AddHexPreamble()

" Other auto commands
autocmd InsertLeave *.py,*.hpp,*.cc,*.c,*.h write " autosave
autocmd InsertLeave *.hpp,*.cc,*.c,*.h TlistUpdate "Update tags

if has("gui_running")
	set guioptions+=b
	set guioptions-=r
endif


nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <leader>ru :MRU<CR>
" alternate buffer
noremap <Leader><Leader> <C-^>
" select all text in current buffer
map <Leader>a ggVG
" Better command mode editing
" down arrow
cnoremap <C-j> <t_kd>
" up arrow
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" Highlight word at cursor without changing position
nnoremap <leader>h *<C-O>
" Remove all trailing white-space characters
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
" Retab and Format the File with Spaces
nnoremap <leader>T :set expandtab<cr>:retab!<cr>
" absolute line numbers in insert mode, relative otherwise for easy movement
"au InsertEnter * :set nu
"au InsertLeave * :set rnu
nmap <leader>f [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

if MySys()=="macos"
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
		"nnoremap <silent> <SwipeLeft> :macaction _cycleWindowsBackwards:<CR>
		"nnoremap <silent> <SwipeRight> :macaction _cycleWindows:<CR>
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


" set encoding
set fileencodings=utf-8,gb2312

"set foldmethod
"autocmd FileType c,cpp  setl fdm=syntax | setl fen
set foldlevel=1000

"yank/paste to/from register b
nmap <leader>y "by
nmap <leader>p "bp
vmap <leader>y "by
vmap <leader>p "bp
vmap <C-a>     "+y
nnoremap <C-a> "+p

" Taglist
"let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1
nmap <leader>gt :TlistToggle<cr>

" WinManager
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

" UltiSnips 
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" a.vim
let g:alternateNoDefaultAlternate = 0

" CScope display
"set cscopequickfix=s-,c-,d-,i-,t-,e-
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
  "set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
	  cs add cscope.out
  endif
  "if filereadable("c:\\boost\\boost_1_35_0\\cscope.out")
	  "cs add c:\boost\boost_1_35_0\cscope.out
  "endif
  set csverb
endif
command -nargs=0 BoostTag call LoadBoostTags()
func LoadBoostTags()
	if MySys()=="windows"
		if filereadable("c:\\boost\\boost_1_35_0\\cscope.out")
			cs add c:\boost\boost_1_35_0\cscope.out
  		endif
		if filereadable("c:\\boost\\boost_1_35_0\\boost\\asio\\tags")
			set tags+=c:\boost\boost_1_35_0\boost\asio\tags
		endif
	endif
endfunc

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

map <C-F12> :!ctags -R --c++-kinds=+p --fields=+ialS --extra=+q
"map <C-F12> :!ctags -R --fields=+ialS --extra=+q .<CR>
map <S-F12> :!cscope -b <CR>


func SetTags()
	set tags=./tags,tags

	if MySys()=="linux"
		set tags+=/home/wangdq/tags/systags
		" The following lines are for NS2, because I sometimes work in a subdir of NS_HOME
		" and sometimes work in NS_HOME and my self-created files are in ./p2pvod
		if filereadable("p2pvod/tags")
			set tags+=p2pvod/tags
		endif
		if filereadable("../tags")
			set tags+=../tags
		endif
	endif
endfunc
call SetTags()

" Disable preview window of completion
set completeopt=longest,menu

" enable C-J,K,L,H to switch windows

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" MiniBufExplorerlet g:miniBufExplMapWindowNavVim = 1
map <Leader>bt :TMiniBufExplorer<cr>
"let g:miniBufExplMapWindowNavArrows = 1
" Buffer switch shortcut
func DeleteCurrentBuffer()
	let cw = bufnr("%")
	exe "bn"
	exe "bd " . cw
endfunc
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

" tabs
nnoremap <M-1> :tabnext 1<CR>
nnoremap <M-2> :tabnext 2<CR>
nnoremap <M-3> :tabnext 3<CR>
nnoremap <M-4> :tabnext 4<CR>
nnoremap <M-5> :tabnext 5<CR>

""""""""""""""""""""""""""""""
" ctrlp
""""""""""""""""""""""""""""""
let g:ctrlp_map = '<leader>t'
set wildignore+=*.so,*.swp,*.zip,*.o,*.d,pnl/*
let g:ctrlp_working_path_mode = 'r'
nmap <silent> <leader>b :CtrlPBuffer<cr>

""""""""""""""""""""""""""""""
" showmarks setting
""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""
" markbrowser setting
""""""""""""""""""""""""""""""
nmap <silent> <leader>mk :MarksBrowser<cr>

""""""""""""""""""""""""""""""
" NERD_Commenter.vim
""""""""""""""""""""""""""""""
let g:NERDMapleader=',n'
let g:NERDShutUp=1

function ChangeCurrDir()
	let _dir = expand("%:p:h")
	exec "cd " . _dir
	unlet _dir
endfunction

if !exists(':CDP')
	command -nargs=0 CDP :silent call ChangeCurrDir()
endif

"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" session manager
let g:session_menu = '&Plugin.session'

" previewtag
" make the preview window not appear with vim start
"let g:Preview_Window_Open = 1
" make you could press F5 key to open or close the preview window, you can also set to other favorite hotkey here
func s:SetPtagMaps()
	map <F5> :PshowORdelete<CR>
	map <S-F5> :Pdelete<CR>
	map <C-F5> :pclose<CR>
	map <F6> :Pswitch<CR>
endfunc


" tex & latex edit
func! ViewCompiledPdf()
	let _pdffile=expand("%:r") . ".pdf"
	if filereadable(_pdffile)
		if MySys()=="macos"
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

	source ~/.vim/ftplugin/tex_latexSuite.vim

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

"Disable sessmgr.vim
let g:loaded_sessmgr=1
"Disable CCTree
let g:loaded_cctree=1
"nmap <tab> k$Ji<cr><esc>
nmap <tab> v$=<esc>


let g:guiTweaked = 0
if has("gui_running")

	function TweakGUI()
	  if g:guiTweaked == 0
		let g:guiTweaked = 1
		"simalt ~x
		if MySys() != "macos"
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

	map <F11> :call TweakGUI()<cr>

	if MySys() == "macos"
		call TweakGUI()
	endif

endif

"session restore
set sessionoptions-=curdir
set sessionoptions+=sesdir
" do not sava global options and maps
set sessionoptions-=options
"set sessionoptions-=localoptions
"mksession w/rviminfo"

nmap <silent> <leader>vs :source ~/.vimrc<cr>
nmap <silent> <leader>ve :e ~/.vimrc<cr>
nmap <silent> <leader>ce :e ~/.vim/snippets/cpp.snippets<cr>
"inoremap <C-A> <esc>I
"inoremap <C-E> <esc>A


" maps for omini
"inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
"inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
"inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
"inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"
inoremap <C-F>             <C-X><C-F>
inoremap <C-D>             <C-X><C-D>
inoremap <C-L>             <C-X><C-L>

"quickfix
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


nnoremap <leader>s :%s/\<<C-r><C-w>\>/

" write all buffers: wa(ll)

"Doxygen toolkits
"let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
"let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="Wang Danqi"
"let g:DoxygenToolkit_licenseTag="My own license\<enter>"   <-- Do not forget ending "\<enter>"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"

"for flymake
"nmap <leader>fme :let g:enable_flymake = 1<cr>
"nmap <leader>fmd :let g:enable_flymake = 0<cr>
"nnoremap <silent> <F8> :Flymake<CR>
command! -nargs=0 -bar Flymake call s:LoadFlyMake()
function s:LoadFlyMake()
	if filereadable("flymake.vim")
		source flymake.vim
	endif
endfunction

"map for autocomplpop
nmap <leader>ace :AcpEnable<cr>
nmap <leader>acd :AcpDisable<cr>
nmap <leader>ste :call s:EnableSupertab()<cr>

" default: diable supertab and use acp
let g:loaded_supertab = 1
" wangdq add this flag to avoid loading supertab.vim multiple times
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

" set python edit environment, including python.vim, pydiction(python auto completion), shortcut definition
function s:SetPythonEnv()

   set textwidth=0
	set expandtab " always convert tab to spaces
	set omnifunc=pythoncomplete#Complete
	" no auto complete when moving cursor in insert mode
	let g:acp_mappingDriven = 1

	"setting python-mode
	let g:pymode_doc_key = 'K'

	if MySys() == "windows"
		"source d:\vimfiles\python.vim
		set complete+=kd:\vimfiles\pydiction isk+=.,(
		map <F12> <ESC>:!"c:\Python25\python.exe" %<CR>
	elseif MySys() == "linux"
		"source ~/vimfiles/python.vim
		"set complete+=k~/vimfiles/pydiction isk+=.,(
		map <F12> <ESC>:!"python" %<CR>
	elseif MySys() == "macos"
		"source ~/vimfiles/python.vim
		"set complete+=k~/vimfiles/pydiction isk+=.,(
		map <F12> <ESC>:!"python" %<CR>
	endif
	let g:py_select_leading_comments = 0
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
	set ts=2	"tab stop
	set sw=2	"shift width
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

" File preambles

func AddHexPreamble()

	call append(0, "\#!/usr/bin/env python")
	call append(1, "\# -*- coding: utf-8 -*-")
	call append(2, "")

endfunc

func AddCHeaderDefine()

	" Starting from line 11 since the Preamble ends at line 9."
	let s:lname = strpart(expand("%"),eval(1 + strridx(expand("%"), "/")))
	let s:label = toupper(substitute(s:lname, "\\.", "_", ""))."_"
	call append(11, "#ifndef ".s:label)
	call append(12, "#define ".s:label)
	call append(13, "")
	call append(14, "")
	call append(15, "")
	call append(16, "")
	call append(17, "#endif")

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

" End of file preambles



