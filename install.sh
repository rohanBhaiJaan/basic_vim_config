#!/bin/bash
plugins_dir="$HOME/.vim/pack/plugins/start"
if [[ ! -d "$plugins_dir" ]]; then
  mkdir $plugins_dir -p
fi

vim_plugin_repos=(
  'https://github.com/ghifarit53/tokyonight-vim'
  'https://github.com/bfrg/vim-c-cpp-modern'
  'https://github.com/tpope/vim-surround'
  'https://github.com/tpope/vim-commentary'
  'https://github.com/vimwiki/vimwiki'
  'https://github.com/junegunn/vader.vim.git'
  'https://github.com/mbbill/undotree'
  'https://github.com/sainnhe/gruvbox-material'
  'https://github.com/tpope/vim-fugitive'
)

for repo in "${vim_plugin_repos[@]}"; do
  dir="${plugins_dir}/${repo##*/}"
  [ ! -d "$dir" ] && git clone $repo "${plugins_dir}/${repo##*/}"
done
