require './src/path_helper'
require './src/system_directories'
require './src/curl_download'
require './src/system_installer'
require './src/git_configurator'
require './src/file_linker'
require './src/file_saver'

DOWNLOAD_VIM_PLUG = CurlDownload.new(
  url: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  dest: PathHelper.home_path(".vim/autoload/plug.vim")
)
DOWNLOAD_GIT_PROMPT = CurlDownload.new(
  url: "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh",
  dest: PathHelper.home_path(".zsh/020_git_prompt.sh")
)
DOWNLOAD_GIT_FREEZE = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-freeze",
  dest: PathHelper.home_path("bin/git-freeze"),
  executable: true
)
DOWNLOAD_GIT_THAW = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-thaw",
  dest: PathHelper.home_path("bin/git-thaw"),
  executable: true
)
DOWNLOAD_GIT_FREEZE_PROMPT = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-freeze.sh",
  dest: PathHelper.home_path("lib/git-freeze.sh")
)

task default: %i[
  system_packages
  install_git_freeze
  download_git_prompt
  gitconfig
  link
  download_vim_plug
  install_vim_plugins
]

task update: %i[
  update_vim_plugins
]

task clean: %i[
  delete_git_prompt
  uninstall_git_freeze
  delete_vim_plug
  delete_vim_plugins
  unlink
]

task system_packages: %i[
  bash_completion
  zsh_completion
  silver_searcher
  fzf
  ruby_install
  chruby
]

task :bash_completion do
  SystemInstaller.for("bash-completion").check_and_install
end

task :zsh_completion do
  SystemInstaller.for("zsh-completions").check_and_install
end

task :silver_searcher do
  SystemInstaller.for("the_silver_searcher").check_and_install
end

task :fzf do
  SystemInstaller.for("fzf").check_and_install
end

task :ruby_install do
  SystemInstaller.for("ruby-install").check_and_install
end

task :chruby do
  SystemInstaller.for("chruby").check_and_install
end

task :download_vim_plug do
  DOWNLOAD_VIM_PLUG.install
end

task :delete_vim_plug do
  DOWNLOAD_VIM_PLUG.clean
end

task :install_vim_plugins do
  sh "vim +'PlugInstall --sync' +qa"
end

task :update_vim_plugins => :install_vim_plugins

task :delete_vim_plugins do
  rm_rf PathHelper.home_path(".vim/plugged")
end

task :download_git_prompt do
  DOWNLOAD_GIT_PROMPT.install
end

task :delete_git_prompt do
  DOWNLOAD_GIT_PROMPT.clean
end

task install_git_freeze: %i[
  download_git_freeze
  download_git_thaw
  download_git_freeze_prompt
]

task uninstall_git_freeze: %i[
  delete_git_freeze
  delete_git_thaw
  delete_git_freeze_prompt
]

task :download_git_freeze do
  DOWNLOAD_GIT_FREEZE.install
end

task :download_git_thaw do
  DOWNLOAD_GIT_THAW.install
end

task :download_git_freeze_prompt do
  DOWNLOAD_GIT_FREEZE_PROMPT.install
end

task :delete_git_freeze do
  DOWNLOAD_GIT_FREEZE.clean
end

task :delete_git_thaw do
  DOWNLOAD_GIT_THAW.clean
end

task :delete_git_freeze_prompt do
  DOWNLOAD_GIT_FREEZE_PROMPT.clean
end

task :gitconfig do
  GitConfigurator.new.setup
end

task :link do
  FileLinker.new.link
end

task :unlink do
  FileLinker.new.unlink
end
