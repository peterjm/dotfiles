require './src/system_directories'
require './src/curl_download'
require './src/system_installer'
require './src/git_configurator'
require './src/file_linker'

def home_path(path)
  File.join ENV['HOME'], path
end

DOWNLOAD_VIM_PLUG = CurlDownload.new(
  url: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  dest: home_path(".vim/autoload/plug.vim")
)
DOWNLOAD_GIT_PROMPT = CurlDownload.new(
  url: "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh",
  dest: home_path(".zsh/020_git_prompt.sh")
)
DOWNLOAD_GIT_FREEZE = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-freeze",
  dest: home_path("bin/git-freeze")
)
DOWNLOAD_GIT_THAW = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-thaw",
  dest: home_path("bin/git-thaw")
)
DOWNLOAD_GIT_FREEZE_PROMPT = CurlDownload.new(
  url: "https://raw.githubusercontent.com/peterjm/git-freeze/master/git-freeze.sh",
  dest: home_path("lib/git_freeze.sh")
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
]

task :bash_completion do
  SystemInstaller.current.check_and_install('bash-completion')
end

task :zsh_completion do
  SystemInstaller.current.check_and_install('zsh-completions')
end

task :silver_searcher do
  SystemInstaller.current.check_and_install('the_silver_searcher')
end

task :fzf do
  SystemInstaller.current.check_and_install('fzf')
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
  rm_rf home_path(".vim/plugged")
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
  system_directories.each do |system_dir|
    link_system_directory(system_dir)
  end
end

task :unlink do
  system_directories.each do |system_dir|
    unlink_system_directory(system_dir)
  end
end

def system_directories(path = "system")
  SystemDirectories.new(path).directories
end

def each_system_file(system_dir)
  return unless File.exist?(system_dir)

  Dir.glob("#{system_dir}/**/**") do |systemfile|
    next unless File.file?(systemfile) || File.symlink?(systemfile)

    relative_file = without_directory(systemfile, system_dir)
    dotfile = home_path(dotify(relative_file))
    systemfile = expanded_path(systemfile)

    yield dotfile, systemfile
  end
end

def link_system_directory(system_dir)
  each_system_file(system_dir) do |dotfile, systemfile|
    make_directory(File.dirname(dotfile))
    link_file(systemfile, dotfile)
  end
end

def unlink_system_directory(system_dir)
  each_system_file(system_dir) do |dotfile, systemfile|
    next unless links_to?(dotfile, systemfile)
    unlink_file(dotfile)

    dir = File.dirname(dotfile)
    remove_directory(dir) if directory_empty?(dir)
  end
end

def make_directory(dir)
  mkdir_p(dir) unless exists_or_symlinked?(dir)
end

def directory_empty?(dir)
  Dir.entries(dir) == %w[. ..]
end

def remove_directory(dir)
  rmdir dir
end

def link_file(src, dest)
  if exists_or_symlinked?(dest)
    warn "#{dest} already exists" unless links_to?(dest, src)
  else
    ln_s src, dest
  end
end

def links_to?(dest, src)
  File.symlink?(dest) && File.readlink(dest) == src
end

def unlink_file(file)
  rm file
end

def without_directory(file, dir)
  file =~ /^#{dir}\/(.*)$/ && $1
end

def dotify(path)
  File.join path.split(File::SEPARATOR).map{ |s| s.sub(/^_/, '.') }
end

def expanded_path(path)
  File.expand_path(path, File.dirname(__FILE__))
end

def non_existing_filename(base)
  return base unless File.exist?(base)

  suffix = 2
  loop do
    name = [base, suffix].join('.')
    return name unless File.exist?(name)
    suffix += 1
  end
end

def has_git_version?(desired_version)
  `git --version`=~ %r{((?:\d+.)*\d+)}
  version_at_least?(desired_version, $1)
end

def version_at_least?(desired_version_string, version_string)
  desired_version = desired_version_string.split('.').map(&:to_i)
  version = version_string.split('.').map(&:to_i)
  (version <=> desired_version) >= 0
end

def exists_or_symlinked?(path)
  File.exist?(path) || File.symlink?(path)
end
