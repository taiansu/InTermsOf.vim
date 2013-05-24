if exists('g:autoloaded_intermsof')
  finish
endif

let g:autoloaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Find The Corresponding Command For File
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#fetchCommand(file) abort
    for obj in g:ito_known_types
        if match(a:file, obj['matcher']) != -1
            return obj['command']
        endif
    endfor
    echo "Don't know how to execute file: " . a:file
    return 0
endfunction

function! intermsof#replaceCommand(type, new_command) abort
    for obj in g:ito_known_types
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


function! intermsof#dispatch(file) abort
    if g:rails_preloader == 'none'
        "Do nothing
    elseif g:rails_preloader == 'spring'
        call intermsof#setSpringCommands()
    elseif g:rails_preloader == 'zeus'
        call intermsof#setZeusCommands()
    endif

    let l:command = intermsof#fetchCommand(a:file)

   if exists("l:command")
       let g:previous_ito_execution = l:command." ".a:file
       call intermsof#iterm#handle(g:previous_ito_execution)
   else
       return
   end

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" Facade Functions
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#clearScreen()
    call intermsof#dispatch('clear')
endfunction

function! intermsof#executeCurrentFile()
    call intermsof#dispatch(expand("%"))
endfunction

function! intermsof#executeCurrentLine()
    call intermsof#dispatch(expand("%") . ":" . line("."))
endfunction

function! intermsof#repeatPreviousExecution()
    if exists("g:previous_ito_execution")
        call intermsof#iterm#handle(g:previous_ito_execution)
    else
        echo "No previous execution exist. Use ,e or ,a to execute this file first."
    endif
endfunction
