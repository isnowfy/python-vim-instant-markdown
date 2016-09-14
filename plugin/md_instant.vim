
if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif
com! -nargs=* Instantmd call OpenMarkdown()

let s:scriptfolder = expand('<sfile>:p:h').'/md_instant'

function! OpenMarkdown()
    let b:md_tick = 0
python << EOF
import sys, os, vim, time
sys.path.append(vim.eval('s:scriptfolder'))
sys.stdout = open(os.path.devnull, 'w')
sys.stderr = open(os.path.devnull, 'w')
vim.command(':autocmd!')
vim.command('autocmd CursorMovedI * call UpdateMarkdown()')
vim.command('autocmd CursorMoved * call UpdateMarkdown()')
vim.command('autocmd VimLeave * call CloseMarkdown()')
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
