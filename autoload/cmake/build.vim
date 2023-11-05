" ==============================================================================
" Location:    autoload/cmake/build.vim
" Description: Functions for building a project
" ==============================================================================

let s:build = {}

let s:buildsys = cmake#buildsys#Get()
let s:fileapi = cmake#fileapi#Get()
let s:logger = cmake#logger#Get()
let s:quickfix = cmake#quickfix#Get()
let s:system = cmake#system#Get()
let s:terminal = cmake#terminal#Get()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Private functions and callbacks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Get dictionary of build arguments from command-line string.
"
" Params:
"     args : List
"         command-line arguments, like target and additional build options
"
" Returns:
"     Dictionary
"         CMake build options, target and native options
"
" Example:
"     args = ['--parallel', '4', 'all', '--', 'VERBOSE=1']
"     return = {
"         \ 'cmake_build_options': ['--parallel', '4'],
"         \ 'target': ['--target', 'all'],
"         \ 'native_build_options': ['VERBOSE=1']
"     \ }
"
function! s:GetBuildArgs(args) abort
    let l:argdict = {}
    let l:argdict.cmake_build_options = []
    let l:argdict.target = []
    let l:argdict.native_build_options = []
    let l:arglist = deepcopy(a:args)
    " Search arguments for one that matches the name of a target.
    call s:RefreshTargets()
    for l:t in s:fileapi.GetBuildTargets()
        let l:match_res = match(l:arglist, '\m\C^' . l:t)
        if l:match_res != -1
            " If found, get target and remove from list of arguments.
            let l:target = l:arglist[l:match_res]
            let l:argdict.target = ['--target', l:target]
            call remove(l:arglist, l:match_res)
            break
        endif
    endfor
    " Search for command-line native build tool arguments.
    let l:match_res = match(l:arglist, '\m\C^--$')
    if l:match_res != -1
        " Get command-line native build tool arguments and remove from list.
        let l:argdict.native_build_options = l:arglist[l:match_res+1:]
        " Remove from list of other arguments.
        call remove(l:arglist, l:match_res, -1)
    endif
    " Get command-line CMake arguments.
    let l:argdict.cmake_build_options = l:arglist
    return l:argdict
endfunction

" Generate quickfix list after running build command.
"
function! s:GenerateQuickfix() abort
    call s:quickfix.Generate(s:terminal.GetOutput())
endfunction

" Refresh list of available CMake build targets.
"
function! s:RefreshTargets() abort
    try
        call s:fileapi.Parse(s:buildsys.GetPathToCurrentConfig())
    catch
    endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Public functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Build a project using the generated buildsystem.
"
" Params:
"     clean : Boolean
"         whether to clean before building
"     args : List
"         build target and other options
"
function! s:build.Build(clean, args) abort
    call s:logger.LogDebug('Invoked: build.Build(%s, %s)',
            \ a:clean, string(a:args))
    let l:path_to_current_config = s:buildsys.GetPathToCurrentConfig()
    let l:build_dir = s:system.Path([l:path_to_current_config], v:true)
    let l:command = [g:cmake_command, '--build', l:build_dir]
    let l:options = {}
    " Parse additional options.
    let l:options = s:GetBuildArgs(a:args)
    " Add CMake build options to the command.
    let l:command += g:cmake_build_options
    let l:command += l:options.cmake_build_options
    if a:clean
        let l:command += ['--clean-first']
    endif
    " Add target to the command, if any was provided.
    let l:command += l:options.target
    " Add native build tool options to the command.
    if len(g:cmake_native_build_options) > 0 ||
            \ len(l:options.native_build_options) > 0
        let l:command += ['--']
        let l:command += g:cmake_native_build_options
        let l:command += l:options.native_build_options
    endif
    call s:fileapi.UpdateQueries(l:build_dir)
    " Run build command.
    let l:run_options = {}
    let l:run_options.callbacks_succ = [
        \ function('s:GenerateQuickfix'),
        \ function('s:RefreshTargets'),
        \ ]
    let l:run_options.callbacks_err = [
        \ function('s:GenerateQuickfix'),
        \  function('s:RefreshTargets'),
        \ ]
    let l:run_options.autocmds_pre = ['CMakeBuildPre']
    let l:run_options.autocmds_succ = ['CMakeBuildSucceeded']
    let l:run_options.autocmds_err = ['CMakeBuildFailed']
    call s:terminal.Run(l:command, 'BUILD', l:run_options)
endfunction

" Install a project.
"
function! s:build.Install() abort
    call s:logger.LogDebug('Invoked: build.Install()')
    let l:path_to_current_config = s:buildsys.GetPathToCurrentConfig()
    let l:build_dir = s:system.Path([l:path_to_current_config], v:true)
    let l:command = [g:cmake_command, '--install', l:build_dir]
    call s:terminal.Run(l:command, 'INSTALL', {})
endfunction

" Get build 'object'.
"
function! cmake#build#Get() abort
    return s:build
endfunction
