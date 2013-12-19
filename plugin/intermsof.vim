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
                \ { 'type': 'plain_coffee-script', 'matcher': '\.coffee', 'command': 'coffee'},
                \ { 'type': 'plain_LiveScript', 'matcher': '\.ls', 'command': 'livescript'},
                \ { 'type': 'javascript_spec', 'matcher': '_spec\.js', 'command': 'mocha'},
                \ { 'type': 'javascript_test', 'matcher': '_test\.js', 'command': 'mocha'},
                \ { 'type': 'plain_javascript', 'matcher': '\.js', 'command': 'node'},
                \ { 'type': 'plain_clojure', 'matcher': '\.clj', 'command': 'lein exec'},
                \ { 'type': 'elixir_unittest', 'matcher': '\.exs', 'command': 'elixir'},
                \ { 'type': 'plain_elixir', 'matcher': '\.ex', 'command': 'elixir'},
                \ { 'type': 'plain_go', 'matcher': '\.go', 'command': 'go run'},
                \ { 'type': 'clear_screen', 'matcher': '^clear$', 'command': 'clear'}
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

",er stand for repeat
map <leader>er :call intermsof#repeatPreviousExecution()<cr>
",ec for execute current file
map <leader>ef :call intermsof#executeCurrentFile()<cr>
",ed for execute current line
map <leader>el :call intermsof#executeCurrentLine()<cr>
",ee stand for clear the terminal screen
map <leader>ec :call intermsof#clearScreen()<cr>

