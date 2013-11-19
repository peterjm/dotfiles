DOTFILES = %w[vim]

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
  Dir.glob("system/**/**") do |systemfile|
    path = remove_directory(systemfile, "system").split(File::SEPARATOR).map{|s|dotify(s)}
    file = path.pop
    make_directory(*path)
    link_file(systemfile, File.join(home_dir, file))
  end

  DOTFILES.each do |file|
    dotfile = File.join(ENV['HOME'], ".#{file}")
    link_file(file, dotfile)
  end
end

def make_directory(*path)
  home_dir = File.join(ENV['HOME'], path)
  mkdir_p(home_dir) unless File.exist?(home_dir)
end

def link_file(src, dest)
  if File.exist? dest
    warn "#{dest} already exists"
  else
    ln_s File.join(File.dirname(__FILE__), src), dest
  end
end

def remove_directory(file, dir)
  file =~ /^#{dir}\/(.*)$/ && $1
end

def dotify(str)
  str.sub(/^_/, '.')
end
