if exists('g:autoloaded_intermsof')
  finish
endif

let g:autoloaded_intermsof = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Find The Corresponding Command For File
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#getFileType(file)
    for obj in g:ito_known_types
        if match(a:file, obj['matcher']) != -1
            let l:type = obj['type']
            return l:type
            break
        endif
    endfor
    echo "Don't know how to execute file: " . a:file
    return 0
endfunction

function! intermsof#getCommand(type)
    if has_key(g:ito_known_commands, a:type) == 0
        echo "Don't know how to execute type: ".a:type
        return 0
    else
        return g:ito_known_commands[a:type]
    endif
endfunction

function! intermsof#getSpringCommand(type)
    let g:ito_known_commands['rspec'] = 'spring rspec'
    let g:ito_known_commands['unit_test'] = 'spring testunit'
    return intermsof#getCommand(a:type)
endfunction

function! intermsof#getZeusCommand(type)
    let g:ito_known_commands['rspec'] = 'zeus test'
    let g:ito_known_commands['unit_test'] = 'zeus test'
    return intermsof#getCommand(a:type)
endfunction

function! intermsof#getOrdinaryCommand(type)
    let g:ito_known_commands['rspec'] = 'bundle exec rspec'
    let g:ito_known_commands['unit_test'] = 'ruby -Itest'
    return intermsof#getCommand(a:type)
endfunction

function! intermsof#dispatch(file)
    let l:type = intermsof#getFileType(a:file)

    if g:rails_preloader == 'spring'
        let l:command = intermsof#getSpringCommand(l:type)
    elseif g:rails_preloader == 'zeus'
        let l:command = intermsof#getZeusCommand(l:type)
    else
        let l:command = intermsof#getOrdinaryCommand(l:type)
    endif

   if exists("l:command")
       let g:previous_ito_execution = l:command." ".a:file
       call intermsof#iterm#handle(g:previous_ito_execution)
   else
       return
   end

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" Execute Command in Target Terminal
""""""""""""""""""""""""""""""""""""""""""""""""""
" function! intermsof#executeInTerminal(command)
"     silent execute ":up"
"     silent execute g:osascript . " '" . a:command . "' " . g:target_tty . " &"
"     silent execute ":redraw!"
" endfunction

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
