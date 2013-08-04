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
           let g:previous_ito_execution = l:command." ".a:file
        end

        for handler in g:intermsof_handlers
           let response = call('intermsof#'.handler.'#handle', [l:command." ".a:file])
           if !empty(response)
               redraw
               return 1
           endif
        endfor
        return 0
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
