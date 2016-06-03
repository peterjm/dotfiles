task :default => [:install_submodules, :build_matcher, :gitconfig, :link, :install_vundles]
task :update => [:update_submodules, :update_vundles]
task :clean => [:delete_vundles, :unlink]

task :install_submodules do
  sh "git submodule update --init"
end

task :update_submodules do
  sh "git submodule foreach git pull origin master"
end

task :install_vundles do
  sh "vim +BundleInstall +qall"
end

task :update_vundles do
  sh "vim +BundleInstall! +qall"
end

task :delete_vundles do
  Dir.glob(home_path(".vim/bundle/**")) do |vundle|
    next if File.symlink?(vundle)
    rm_r vundle
  end
end

task :build_matcher do
  sh "cd submodules/matcher && make"
end

task :gitconfig do
  unless File.exist?(File.join("gitconfigure", "gitconfig.personal"))
    warn "create a gitconfig.personal based on gitconfig.personal.template" and return
  end

  tmp_gitconfig = "gitconfig.tmp"
  current_gitconfig = "system/_gitconfig"

  `touch #{tmp_gitconfig}`
  `cat gitconfigure/gitconfig.personal >> #{tmp_gitconfig}`
  `cat gitconfigure/gitconfig >> #{tmp_gitconfig}`
  `cat gitconfigure/gitconfig_18 >> #{tmp_gitconfig}` if has_git_version?("1.8")

  if !File.exist?(current_gitconfig)
    mv tmp_gitconfig, current_gitconfig
  elsif !system("diff -q #{tmp_gitconfig} #{current_gitconfig}")
    system("diff #{current_gitconfig} #{tmp_gitconfig}")
    old_gitconfig = File.join("gitconfigure", "gitconfig.old")
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

def system_directories
  [
    "system",
    dropbox_path("system/common"),
    dropbox_path("system/#{hostname}")
  ]
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

def home_path(path)
  File.join ENV['HOME'], path
end

def dropbox_path(path)
  home_path File.join("Dropbox", path)
end

def hostname
  `hostname -s`.strip
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
