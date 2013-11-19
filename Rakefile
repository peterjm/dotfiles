task :default => [:update_submodules, :install_vundles, :gitconfig, :link]

task :update_submodules do
  sh "git submodule update --init"
end

task :install_vundles do
  sh "vim +BundleInstall +qall"
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

  if !File.exist?(current_gitconfig)
    mv tmp_gitconfig, current_gitconfig
  elsif !system("diff -q #{tmp_gitconfig} #{current_gitconfig}")
    system("diff #{current_gitconfig} #{tmp_gitconfig}")
    old_gitconfig = File.join("gitconfigure", "gitconfig.old")
    warn "moved existing #{current_gitconfig} to #{old_gitconfig}"
    mv current_gitconfig, old_gitconfig
    mv tmp_gitconfig, current_gitconfig
  else
    rm tmp_gitconfig
  end
end

task :link do
  system_directories.each do |system_dir|
    link_system_directory(system_dir)
  end
end

def system_directories
  [
    "system",
    dropbox_path("system/common"),
    dropbox_path("system/#{hostname}")
  ]
end

def link_system_directory(system_dir)
  return unless File.exist?(system_dir)

  Dir.glob("#{system_dir}/**/**") do |systemfile|
    next if File.directory?(systemfile)

    relative_file = remove_directory(systemfile, system_dir)
    dotfile = dotify(relative_file)

    make_directory(File.dirname(dotfile))
    link_file(systemfile, dotfile)
  end
end

def make_directory(dir)
  home_dir = home_path(dir)
  mkdir_p(home_dir) unless File.exist?(home_dir)
end

def link_file(src, dest)
  linkname = home_path(dest)
  if File.exist? linkname
    warn "#{linkname} already exists"
  else
    ln_s File.expand_path(src, File.dirname(__FILE__)), linkname
  end
end

def remove_directory(file, dir)
  file =~ /^#{dir}\/(.*)$/ && $1
end

def dotify(path)
  File.join path.split(File::SEPARATOR).map{ |s| s.sub(/^_/, '.') }
end

def home_path(path)
  File.join ENV['HOME'], path
end

def dropbox_path(path)
  home_path File.join("Dropbox", path)
end

def hostname
  `hostname -s`
end
