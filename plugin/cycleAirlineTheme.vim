" CycleAirlineTheme.vim
" cycle through available AirlineThemes
"
" TODO:  Allow selecting the scheme from a list (like csExplorer.vim).
"        Notification of same-named schemes in different directories.
"        Allow blacklisting specific AirlineTheme files.

let s:schemes = "\n".globpath(&rtp, "autoload/airline/themes/*.vim")."\n"
let s:currentfile = ""
let s:currentname = ""

function! g:CycleAirlineTheme(direction)
    if exists("g:airline_theme") && g:airline_theme != s:currentname
        " The user must have selected a AirlineTheme manually; try
        " to find it and choose the next one after it
        let nextfile = substitute(s:schemes, '.*\n\([^\x0A]*[/\\]'.g:airline_theme.'\.vim\)\n.*', '\1', '')
        if nextfile == s:schemes
            let s:currentfile = ""
        else
            let s:currentfile = nextfile
        endif
    endif

    if a:direction >= 0
        " Find the current file name, and select the next one.
        " No substitution will take place if the current file is not
        "   found or is the last in the list.
        let nextfile = substitute(s:schemes, '.*\n'.s:currentfile.'\n\([^\x0A]\+\)\n.*', '\1', '')
        " If the above worked, there will be no control chars in
        "   nextfile, so this will not substitute; otherwise, this will
        "   choose the first file in the list.
        let nextfile = substitute(nextfile, '\n\+\([^\x0A]\+\)\n.*', '\1', '')
    else
        let nextfile = substitute(s:schemes, '.*\n\([^\x0A]\+\)\n'.s:currentfile.'\n.*', '\1', '')
        let nextfile = substitute(nextfile, '.*\n\([^\x0A]\+\)\n\+', '\1', '')
    endif

    if nextfile != s:schemes
        let clrschm = substitute(nextfile, '^.*[/\\]\([^/\\]\+\)\.vim$', '\1', '')
        " In case the color scheme does not set this variable, empty it so we can tell.
        unlet! g:airline_theme
        exec 'AirlineTheme '.clrschm
        redraw
        if exists("g:airline_theme")
            let s:currentname = g:airline_theme
            if clrschm != g:airline_theme
                " Let user know AirlineTheme did not set g:airline_theme properly
                echomsg 'AirlineTheme' clrschm 'set g:airline_theme to' g:airline_theme
            endif
        else
            let s:currentname = ""
            echomsg 'AirlineTheme' clrschm 'did not set g:airline_theme'
        endif
        "echo s:currentname.' ('.nextfile.')'
    endif

    let s:currentfile = nextfile
    echo s:currentname
endfunction

function! g:CycleAirlineThemeRefresh()
    let s:schemes = "\n".globpath(&rtp, "autoload/airline/themes/*.vim")."\n"
endfunction

command! CycleAirlineThemeNext :call g:CycleAirlineTheme(1)
command! CycleAirlineThemePrev :call g:CycleAirlineTheme(-1)
command! CycleAirlineThemeRefresh :call g:CycleAirlineThemeRefresh()
nnoremap <f4> :CycleAirlineThemeNext<cr>
nnoremap <f3> :CycleAirlineThemePrev<cr>

