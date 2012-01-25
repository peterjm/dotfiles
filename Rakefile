task :default => [:update, :command_t, :link]

task :update do
  sh "git submodule update --init"
end

task :link do
  %w[ackrc bash_profile bashrc bashrc.extras gemrc gitconfig gitignore gvimrc vimrc vim].each do |file|
    dotfile = File.join(ENV['HOME'], ".#{file}")
    link_file(file, dotfile)
  end

  %w[bin].each do |dir|
    home_dir = File.join(ENV['HOME'], dir)
    mkdir_p(home_dir) unless File.exist?(home_dir)
    Dir["#{dir}/**"].each do |file|
      link_file(file, File.join(ENV['HOME'], file))
    end
  end
end

task :command_t do
  puts "Compiling Command-T plugin..."
  Dir.chdir "vim/bundle/command-t" do
    sh("rake make")
  end
end

def link_file(src, dest)
  if File.exist? dest
    warn "#{dest} already exists"
  else
    ln_s File.join(File.dirname(__FILE__), src), dest
  end
end
