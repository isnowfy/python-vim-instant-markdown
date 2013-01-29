
if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

let s:scriptfolder = expand('<sfile>:p:h').'/md_instant'

function! OpenMarkdown()
    let b:md_tick = ""
python << EOF
import sys, os, vim, time
sys.path.append(vim.eval('s:scriptfolder'))
sys.stdout = open(os.path.devnull, 'w')
sys.stderr = open(os.path.devnull, 'w')
import md_instant
md_instant.main()
md_instant.startbrowser()
time.sleep(3)
md_instant.sendall(vim.current.buffer)
EOF
endfunction

function! UpdateMarkdown()
    if (b:md_tick != b:changedtick)
        let b:md_tick = b:changedtick
python << EOF
md_instant.sendall(vim.current.buffer)
EOF
    endif
endfunction
function! CloseMarkdown()
python << EOF
md_instant.stopserver()
EOF
endfunction

" Only README.md is recognized by vim as type markdown. Do this to make ALL .md files markdown
autocmd BufWinEnter *.{md,mkd,mkdn,mdown,mark*} silent setf markdown

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mdown,mark*} silent call UpdateMarkdown()
autocmd BufWinEnter *.{md,mkd,mkdn,mdown,mark*} silent call OpenMarkdown()
autocmd BufWinLeave *.{md,mkd,mkdn,mdown,mark*} silent call CloseMarkdown()
