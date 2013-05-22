" InTermsOf.vim - Remote controls iTerm from MacVim
" Maintainer:   taiansu
" Version:      0.1

if exists('g:autoloaded_intermsof')
  finish
endif

let g:autoloaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETUP GLOBAL VARIABLES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ito_known_types = [
                \ { 'matcher': '_spec\.rb', 'type': 'rspec'},
                \ { 'matcher': '_test\.rb', 'type': 'unit_test'},
                \ { 'matcher': '\.rb', 'type': 'ruby'},
                \ { 'matcher': '\.py', 'type': 'python'},
                \ { 'matcher': '_test\.js', 'type': 'javascript_test'},
                \ { 'matcher': '\.js', 'type': 'javascript'},
                \ { 'matcher': '^clear$', 'type': 'clear'},
            \ ]

let g:ito_known_commands = {
                \ 'ruby': 'ruby',
                \ 'python': 'python',
                \ 'javascript_test': 'mocha',
                \ 'javascript': 'node',
                \ 'clear': ''
            \}

if !exists("g:rails_preloader")
    let g:rails_preloader="none"
end

let g:focus_vim = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS AND KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ExecuteInTerminal call intermsof#executeInTerminal()
command! ExecuteCurrentFile call intermsof#executeCurrentFile()
command! ExecuteCurrentLine call intermsof#executeCurrentLine()
command! RepeatPreviousExecution call intermsof#repeatPreviousExecution()

" key for changing the target_tty and rails_preloader
map <leader><C-r> :let g:rails_preloader="spring"

",e for execute entire file
map <leader>e :call intermsof#executeCurrentFile()<cr>
",E for execute line
map <leader>E :call intermsof#executeCurrentLine()<cr>
",r stand for repeat
map <leader>r :call intermsof#repeatPreviousExecution()<cr>
",c stand for clear
map <leader>c :call intermsof#clear()<cr>

