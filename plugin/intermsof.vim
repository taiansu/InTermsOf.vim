" InTermsOf.vim - Remote controls iTerm from MacVim
" Maintainer:   taiansu
" Version:      0.3

if exists('g:loaded_intermsof')
  finish
endif

let g:loaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" SETUP GLOBAL VARIABLES
""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ito_known_types = [
                \ { 'type': 'rspec', 'matcher': '_spec\.rb', 'command': 'bundle exec rspec'},
                \ { 'type': 'rspec_dir', 'matcher': 'spec', 'command': 'bundle exec rspec'},
                \ { 'type': 'ruby_unit_test', 'matcher': '_test\.rb', 'commad': 'ruby -Itest'},
                \ { 'type': 'ruby_unit_test_dir', 'matcher': 'test', 'commad': 'ruby -Itest'},
                \ { 'type': 'plain_ruby', 'matcher': '\.rb', 'command': 'ruby'},
                \ { 'type': 'plain_python', 'matcher': '\.py', 'command': 'python'},
                \ { 'type': 'plain_coffee-script', 'matcher': '\.coffee', 'command': 'coffee'},
                \ { 'type': 'plain_LiveScript', 'matcher': '\.ls', 'command': 'lsc'},
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

let g:refocus_vim = 0

""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS AND KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""
command! RunInTerminal call intermsof#runInTerminal()
command! RunCurrentFile call intermsof#runCurrentFile()
command! RunCurrentLine call intermsof#runCurrentLine()
command! RepeatPreviousExecution call intermsof#repeatPreviousExecution()

" key for changing the target_tty and rails_preloader
map <leader><C-e> :let g:rails_preloader="spring"

",er stand for repeat
map <leader>er :call intermsof#repeatPreviousExecution()<cr>
",ec for run current file
map <leader>ef :call intermsof#runCurrentFile()<cr>
",ee stand for run current line
map <leader>ee :call intermsof#runCurrentLine()<cr>
",ea stand for run all specs
map <leader>ee :call intermsof#runAll()<cr>
",ed for clear the terminal screen
map <leader>ed :call intermsof#clearScreen()<cr>

