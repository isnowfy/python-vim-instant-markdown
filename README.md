#python-vim-instant-markdown
fork from isnowfy, updated code and folder structure to support pathogen

thanks for scturtle and his vim-instant-markdown-py project

##Requirements
* python and markdown and pygments package
* vim should have python support, you can check it `vim --version | grep +python`

##Installation
* `pip install markdown` and `pip install pygments`
* put `md_instant.vim` and the folder `md_instant` in `~/.vim/plugin` or use pathogen

##Run
with `:Instantmd` command, the browser will automatically open, if not please browse the <http://localhost:7000/>
