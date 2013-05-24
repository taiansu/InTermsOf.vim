if exists('g:autoloaded_intermsof_iterm')
  finish
endif
let g:autoloaded_intermsof_iterm = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Execute Command in iTerm
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#iterm#handle(command) abort
  "TODO fix MacVim
  return s:osascript(
    \ 'tell application "iTerm"',
    \   'activate',
    \   'tell the first terminal',
    \     'tell current session',
    \       'write text ("'.a:command.'" as string)',
    \     'end tell',
    \   'end tell',
    \ 'end tell',
    \ g:focus_vim ? 'tell application "MacVim"' : '',
    \ g:focus_vim ?   'tell the last window' : '',
    \ g:focus_vim ?     'activate' : '',
    \ g:focus_vim ?   'end tell': '',
    \ g:focus_vim ? 'end tell': '')
endfunction

function! s:osascript(...) abort
  call system('osascript'.join(map(copy(a:000), '" -e ".shellescape(v:val)'), ''))
  return !v:shell_error
endfunction

function! s:escape(string)
  return '"'.escape(a:string, '"\').'"'
endfunction
