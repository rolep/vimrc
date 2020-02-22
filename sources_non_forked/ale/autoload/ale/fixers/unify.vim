" Author: rolep <oleg@rolep.me>
" Description: Fixing files with unify.

call ale#Set('python_unify_executable', 'unify')
call ale#Set('python_unify_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('python_unify_options', '')

function! ale#fixers#unify#Fix(buffer) abort
    let l:executable = ale#python#FindExecutable(
    \   a:buffer,
    \   'python_unify',
    \   ['unify'],
    \)

    if !executable(l:executable)
        return 0
    endif

    let l:options = ale#Var(a:buffer, 'python_unify_options')

    return {
    \   'command': ale#Escape(l:executable)
    \       . (!empty(l:options) ? ' ' . l:options : '')
    \       . ' --in-place'
    \       . ' %t',
    \   'read_temporary_file': 1,
    \}
endfunction
