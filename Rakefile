task :default => [:update, :command_t, :link]

task :update do
  sh "git submodule update --init"
end

task :link do
  %w[ackrc bash_profile bashrc bashrc.extras gemrc gitconfig gitignore gvimrc vimrc vim].each do |file|
    dotfile = File.join(ENV['HOME'], ".#{file}")
    if File.exist? dotfile
      warn "~/.#{file} already exists"
    else
      ln_s File.join(File.dirname(__FILE__), file), dotfile
    end
  end
end

task :command_t do
  puts "Compiling Command-T plugin..."
  Dir.chdir "vim/bundle/command-t" do
    sh("rake make")
  end
end

