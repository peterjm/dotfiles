DIRECTORIES = %w[bin scratch lib]
DOTFILES = %w[ackrc bash_profile bashrc bashrc.extras gemrc gitignore gvimrc vimrc vim pryrc bundle]

task :default => [:update_submodules, :install_vundles, :gitconfig, :make_directories, :link]

task :update_submodules do
  sh "git submodule update --init"
end

task :install_vundles do
  sh "vim +BundleInstall +qall"
end

task :gitconfig do
  unless File.exist?("gitconfig.personal")
    warn "create a gitconfig.personal based on gitconfig.personal.template" and return
  end

  tmp_gitconfig = File.join "/tmp", "gitconfig.tmp"
  current_gitconfig = File.join(ENV['HOME'], ".gitconfig")

  system("touch #{tmp_gitconfig}")
  system("cat gitconfig.personal >> #{tmp_gitconfig}")
  system("cat gitconfig >> #{tmp_gitconfig}")

  if !File.exist?(current_gitconfig)
    mv tmp_gitconfig, current_gitconfig
  elsif !system("diff -q #{tmp_gitconfig} #{current_gitconfig}")
    old_gitconfig = File.join("/tmp", "gitconfig.old")
    warn "moved existing #{current_gitconfig} to #{old_gitconfig}"
    mv current_gitconfig, old_gitconfig
    mv tmp_gitconfig, current_gitconfig
  else
    rm tmp_gitconfig
  end
end

task :make_directories do
  DIRECTORIES.each do |dir|
    home_dir = File.join(ENV['HOME'], dir)
    mkdir_p(home_dir) unless File.exist?(home_dir)
  end
end

task :link => :make_directories do
  DOTFILES.each do |file|
    dotfile = File.join(ENV['HOME'], ".#{file}")
    link_file(file, dotfile)
  end

  DIRECTORIES.each do |dir|
    Dir["#{dir}/**"].each do |file|
      link_file(file, File.join(ENV['HOME'], file))
    end
  end
end

def link_file(src, dest)
  if File.exist? dest
    warn "#{dest} already exists"
  else
    ln_s File.join(File.dirname(__FILE__), src), dest
  end
end
