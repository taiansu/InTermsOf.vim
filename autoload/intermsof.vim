if exists('g:autoloaded_intermsof')
  finish
endif

let g:autoloaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Find The Corresponding Command For File
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#fetchCommand(file) abort
    for obj in g:intermsof_known_types
        if match(a:file, obj['matcher']) != -1
            return obj['command']
        endif
    endfor
    echo "Don't know how to run this file: " . a:file
    return 0
endfunction

function! intermsof#replaceCommand(type, new_command) abort
    for obj in g:intermsof_known_types
        if obj['type'] == a:type
            let obj['command'] = a:new_command
            return
        endif
    endfor
endfunction

function! intermsof#setSpringCommands()
    call intermsof#replaceCommand('rspec', 'spring rspec')
    call intermsof#replaceCommand('unit_test', 'spring testunit')
endfunction

function! intermsof#setZeusCommands()
    call intermsof#replaceCommand('rspec', 'zeus test')
    call intermsof#replaceCommand('unit_test', 'zeus test')
endfunction

function! intermsof#setPreloader(rails_preloader)
    if a:rails_preloader == 'none'
        "Do nothing
    elseif a:rails_preloader == 'spring'
        call intermsof#setSpringCommands()
    elseif a:rails_preloader == 'zeus'
        call intermsof#setZeusCommands()
    endif
endfunction


function! intermsof#dispatch(file) abort

    call intermsof#setPreloader(g:rails_preloader)
    let l:command = intermsof#fetchCommand(a:file)

    if exists("l:command")
        if a:file != 'clear'
           let g:previous_intermsof_execution = l:command." ".a:file
        end

        let response = call('intermsof#run', [l:command." ".a:file])
        if !empty(response)
          redraw
          return 1
        else
          return 0
        endif
    else
        return 0
    end

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" Facade Functions
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#clearScreen()
    call intermsof#dispatch('clear')
endfunction

function! intermsof#runCurrentFile()
    call intermsof#dispatch(expand("%"))
endfunction

function! intermsof#runCurrentLine()
    call intermsof#dispatch(expand("%") . ":" . line("."))
endfunction

function! intermsof#repeatPreviousExecution()
    if exists("g:previous_intermsof_execution")
        call intermsof#iterm#handle(g:previous_intermsof_execution)
    else
        call intermsof#runCurrentFile()
    endif
endfunction

function! intermsof#runAll()
  let spec_dir = matchstr(%:p:h, '.+(spec|test)')
  if !empty(spec_dir)
    call intermsof#dispatch(expand("%:p:h"))
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" Core Functions
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#run(...) abort
  let b:osascript = intermsof#osascript(join(a:000,' '))
  return s:systemCall(b:osascript)
endfunction

function! s:systemCall(script) abort
  call system(a:script)
  return !v:shell_error
endfunction

function! intermsof#osascript(command) abort
  if $TERM_PROGRAM ==? "iTerm.app"
    return 'osascript'.join(map([
      \ 'tell application "iTerm"',
      \   'activate',
      \   'tell the first terminal',
      \     'tell current session',
      \       'write text ("'.a:command.'" as string)',
      \     'end tell',
      \   'end tell',
      \ 'end tell',
      \ g:refocus_macvim ? 'tell application "MacVim" tell the last window activate end tell end tell' : ''],
    \'" -e ".shellescape(v:val)'), '')
  elseif $TERM_PROGRAM ==? "Apple_Terminal"
    return 'osascript'.join(map([
      \ 'on is_running(appName)',
      \   'tell application "System Events" to (name of processes) contains appName',
      \ 'end is_running',
      \ 'set trmRunning to is_running("Terminal")',
      \ 'tell application "Terminal"',
      \   'if trmRunning then',
      \     'do script ("'.a:command.'") in window 0',
      \   'else',
      \     'do script ("'.a:command.'")',
      \     'activate',
      \   'end if',
      \ 'end tell',
      \ g:refocus_macvim ? 'tell application "MacVim" tell the last window activate end tell end tell' : ''],
    \'" -e ".shellescape(v:val)'), '')
  endif
endfunction
