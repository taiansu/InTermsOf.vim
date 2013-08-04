" InTermsOf.vim - Remote controls iTerm from MacVim
" Maintainer:   taiansu
" Version:      0.2

if exists('g:loaded_intermsof')
  finish
endif

let g:loaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" SETUP GLOBAL VARIABLES
""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ito_known_types = [
                \ { 'type': 'rspec', 'matcher': '_spec\.rb', 'command': 'bundle exec rspec'},
                \ { 'type': 'ruby_unit_test', 'matcher': '_test\.rb', 'commad': 'ruby -Itest'},
                \ { 'type': 'plain_ruby', 'matcher': '\.rb', 'command': 'ruby'},
                \ { 'type': 'plain_python', 'matcher': '\.py', 'command': 'python'},
                \ { 'type': 'javascript_spec', 'matcher': '_spec\.js', 'command': 'mocha'},
                \ { 'type': 'javascript_test', 'matcher': '_test\.js', 'command': 'mocha'},
                \ { 'type': 'plain_javascript', 'matcher': '\.js', 'command': 'node'},
                \ { 'type': 'clear_screen', 'matcher': '^clear$', 'command': 'clear'},
                \ ]

let g:intermsof_handlers = [
            \ 'iterm',
            \ 'terminal'
            \ ]

if !exists("g:rails_preloader")
    let g:rails_preloader="none"
end

let g:focus_vim = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS AND KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""
command! ExecuteInTerminal call intermsof#executeInTerminal()
command! ExecuteCurrentFile call intermsof#executeCurrentFile()
command! ExecuteCurrentLine call intermsof#executeCurrentLine()
command! RepeatPreviousExecution call intermsof#repeatPreviousExecution()

" key for changing the target_tty and rails_preloader
map <leader><C-r> :let g:rails_preloader="spring"

",er for execute entire file
map <leader>er :call intermsof#executeCurrentFile()<cr>
",ed for execute line
map <leader>ed :call intermsof#executeCurrentLine()<cr>
",ee stand for repeat
map <leader>ee :call intermsof#repeatPreviousExecution()<cr>
",ec stand for clear
map <leader>ec :call intermsof#clearScreen()<cr>

