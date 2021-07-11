require './src/curl_download'

def home_path(path)
  File.join ENV['HOME'], path
end

VIM_PLUG_LOCATION = home_path(".vim/autoload/plug.vim")
GIT_PROMPT_LOCATION = home_path(".zsh/020_git_prompt.sh")

task default: %i[
  system_packages
  download_git_prompt
  install_submodules
  gitconfig
  link
  download_vim_plug
  install_vim_plugins
]

task update: %i[
  update_submodules
  update_vim_plugins
]

task clean: %i[
  delete_git_prompt
  delete_vim_plug
  delete_git_prompt
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
  install_system_package('bash-completion')
end

task :zsh_completion do
  install_system_package('zsh-completions')
end

task :silver_searcher do
  install_system_package('the_silver_searcher')
end

task :fzf do
  install_system_package('fzf')
end

task :install_submodules do
  sh "git submodule update --init"
end

task :update_submodules do
  sh "git submodule foreach git pull origin master"
end

task :download_vim_plug do
  CurlDownload.new(
    url: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
    dest: VIM_PLUG_LOCATION
  ).install
end

task :delete_vim_plug do
  rm VIM_PLUG_LOCATION
end

task :install_vim_plugins do
  sh "vim +'PlugInstall --sync' +qa"
end

task :update_vim_plugins => :install_vim_plugins

task :delete_vim_plugins do
  rm_r home_path(".vim/plugged/**")
end

task :download_git_prompt do
  CurlDownload.new(
    url: "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh",
    dest: GIT_PROMPT_LOCATION
  ).install
end

task :delete_git_prompt do
  rm GIT_PROMPT_LOCATION
end

task :gitconfig do
  current_gitconfig = "system/_gitconfig"
  tmp_gitconfig = "gitconfig.tmp"

  `touch #{tmp_gitconfig}`

  gitconfig_files.each do |file|
    File.read(file).lines.map(&:strip).reject(&:empty?).each do |config_line|
      set_git_config(tmp_gitconfig, config_line)
    end
  end

  unless confirm_git_config(tmp_gitconfig, 'user.name', 'user.email', 'github.user')
    warn "create a gitconfig in Dropbox/dotfiles/gitconfigure with system-specific settings"
    `rm #{tmp_gitconfig}`
    return
  end

  if !File.exist?(current_gitconfig)
    mv tmp_gitconfig, current_gitconfig
  elsif !system("diff -q #{tmp_gitconfig} #{current_gitconfig}")
    system("diff #{current_gitconfig} #{tmp_gitconfig}")
    old_gitconfig = non_existing_filename("gitconfig.old")
    warn "moved existing #{current_gitconfig} to #{old_gitconfig}"
    mv current_gitconfig, old_gitconfig
    mv tmp_gitconfig, current_gitconfig
  else
    `rm #{tmp_gitconfig}`
  end
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

def set_git_config(filename, setting_and_value)
  `git config -f #{filename} #{setting_and_value}`
end

def confirm_git_config(filename, *settings)
  settings.each do |setting|
    unless `git config -f #{filename} #{setting}`
      warn "git configuration for '#{setting}' is missing"
    end
  end
end

def gitconfig_files
  system_directories("gitconfigure")
    .map { |path| File.join(path, "gitconfig") }
    .select { |file| File.exist?(file) }
end

def system_directories(path = "system")
  [
    path,
    dropbox_path("dotfiles", path, "common"),
    (dropbox_path("dotfiles", path, computer_name) unless computer_name.nil?)
  ].compact
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

def dropbox_path(*path)
  home_path File.join("Dropbox", *path)
end

def computer_name
  prompt_host || hostname
end

def prompt_host
  presence(ENV['PROMPT_HOST'])
end

def hostname
  presence(`hostname -s`)
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

class SystemInstaller
  include FileUtils

  def check_and_install(name)
    package_name = system_package_name(name)
    if installed?(package_name)
      puts "#{package_name} already installed"
    else
      install(package_name)
    end
  end

  def system_package_name(name)
    name
  end
end

class NoInstaller < SystemInstaller
  def check_and_install(package_name)
    puts "ERROR: no system installer; couldn't install '#{package_name}'"
  end
end

class BrewInstaller < SystemInstaller
  def installed?(package_name)
    `brew list`.split.include?(package_name)
  end

  def install(package_name)
    sh "brew install #{package_name}"
  end
end

class AptGetInstaller < SystemInstaller
  PACKAGE_NAMES = {
    'the_silver_searcher' => 'silversearcher-ag',
  }

  def installed?(package_name)
    `apt-cache policy #{package_name}` !~ /Installed: \(none\)/
  end

  def install(package_name)
    sh "sudo apt-get install -y #{package_name}"
  end

  def system_package_name(name)
    PACKAGE_NAMES[name] || name
  end
end

def install_system_package(package_name)
  system_installer.check_and_install(package_name)
end

def system_installer
  if ENV['SPIN']
    AptGetInstaller.new
  elsif !`which brew`.empty?
    BrewInstaller.new
  else
    NoInstaller.new
  end
end

def presence(string)
  return nil if string.nil?
  string = string.strip
  string.empty? ? nil : string
end
