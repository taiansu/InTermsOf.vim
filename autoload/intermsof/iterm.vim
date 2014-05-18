if exists('g:autoloaded_intermsof_iterm')
  finish
endif
let g:autoloaded_intermsof_iterm = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Execute Command in iTerm
""""""""""""""""""""""""""""""""""""""""""""""""""
function! intermsof#iterm#handle(command) abort
  if $TERM_PROGRAM !=# 'iTerm.app' && !(has('gui_macvim') && has('gui_running'))
    return 0
  endif

  return s:osascript(
    \ 'tell application "iTerm"',
    \   'activate',
    \   'tell the first terminal',
    \     'tell current session',
    \       'write text ("'.a:command.'" as string)',
    \     'end tell',
    \   'end tell',
    \ 'end tell',
    \ g:refocus_vim ? 'tell application "MacVim"' : '',
    \ g:refocus_vim ?   'tell the last window' : '',
    \ g:refocus_vim ?     'activate' : '',
    \ g:refocus_vim ?   'end tell': '',
    \ g:refocus_vim ? 'end tell': '')
endfunction

function! s:osascript(...) abort
  call system('osascript'.join(map(copy(a:000), '" -e ".shellescape(v:val)'), ''))
  return !v:shell_error
endfunction

function! s:escape(string)
  return '"'.escape(a:string, '"\').'"'
endfunction
