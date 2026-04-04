require './src/path_helper'
require './src/system_directories'
require './src/curl_download'
require './src/git_configurator'
require './src/file_linker'
require './src/file_saver'
require './src/ruby_helper'

DOWNLOAD_VIM_PLUG = CurlDownload.new(
  url: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  dest: PathHelper.home_path(".vim/autoload/plug.vim")
)
DOWNLOAD_GIT_FREEZE = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/main/git-freeze",
  dest: PathHelper.home_path("bin/git-freeze"),
  executable: true
)
DOWNLOAD_GIT_THAW = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/main/git-thaw",
  dest: PathHelper.home_path("bin/git-thaw"),
  executable: true
)
DOWNLOAD_GIT_FREEZE_PROMPT = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/main/git-freeze.sh",
  dest: PathHelper.home_path("lib/git-freeze.sh")
)
RUBY_GEMS = [
  "light_me_up"
].each_with_object({}) { |gem_name, map| map[gem_name.gsub("-", "_")] = gem_name }

task default: %i[
  install_system_packages
  install_git_freeze
  install_latest_ruby
  gitconfig
  link
  download_vim_plug
  install_vim_plugins
  install_gems
]

task update: %i[
  update_vim_plugins
  update_gems
]

task clean: %i[
  uninstall_gems
  uninstall_git_freeze
  delete_vim_plug
  delete_vim_plugins
  unlink
]

task :install_system_packages do
  sh "brew bundle --file=Brewfile"
end

task install_gems: RUBY_GEMS.keys.map { |gem| "install_#{gem}_gem" }

task update_gems: RUBY_GEMS.keys.map { |gem| "update_#{gem}_gem" }

task uninstall_gems: RUBY_GEMS.keys.map { |gem| "uninstall_#{gem}_gem" }

RUBY_GEMS.each do |task_name, gem_name|
  task "install_#{task_name}_gem" do
    RubyHelper.new.install_gem(gem_name)
  end

  task "update_#{task_name}_gem" do
    RubyHelper.new.update_gem(gem_name)
  end

  task "uninstall_#{task_name}_gem" do
    RubyHelper.new.uninstall_gem(gem_name)
  end
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

task :install_latest_ruby do
  RubyHelper.new.install_ruby
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
