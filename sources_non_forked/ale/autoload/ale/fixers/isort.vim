" Author: w0rp <devw0rp@gmail.com>
" Description: Fixing Python imports with isort.

call ale#Set('python_isort_executable', 'isort')
call ale#Set('python_isort_options', '')
call ale#Set('python_isort_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('python_isort_change_directory', 1)

function! ale#fixers#isort#Fix(buffer) abort
    let l:cd_string = ''

    if ale#Var(a:buffer, 'python_isort_change_directory')
        " isort only checks for setup.cfg in the packages above its current
        " directory before falling back to user and global configs.
        " Run from project root, if found, otherwise buffer dir.
        let l:project_root = ale#python#FindProjectRoot(a:buffer)
        let l:cd_string = l:project_root isnot# ''
        \   ? ale#path#CdString(l:project_root)
        \   : ale#path#BufferCdString(a:buffer)
    endif

    let l:options = ale#Var(a:buffer, 'python_isort_options')

    let l:executable = ale#python#FindExecutable(
    \   a:buffer,
    \   'python_isort',
    \   ['isort'],
    \)

    if !executable(l:executable)
        return 0
    endif

    " return {
    " \   'command': ale#path#BufferCdString(a:buffer)
    " \   .   ale#Escape(l:executable) . (!empty(l:options) ? ' ' . l:options : '') . ' -',
    " \}
    return {
    \   'command': l:cd_string . ale#Escape(l:executable)
    \       . (!empty(l:options) ? ' ' . l:options : '') . ' -',
    \}
endfunction
