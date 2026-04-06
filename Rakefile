require './src/path_helper'
require './src/system_directories'
require './src/curl_download'
require './src/git_configurator'
require './src/file_linker'
require './src/file_saver'
require './src/local_gem_installer'

SETUP_DIR = PathHelper.home_path(".dotfiles_setup")

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
LOCAL_GEMS = [
  LocalGemInstaller.new(
    name: "light_me_up",
    repo: "git@github.com:peterjm/light_me_up.git",
    path: PathHelper.home_path("src/light_me_up"),
    setup_dir: SETUP_DIR,
  ),
  LocalGemInstaller.new(
    name: "related_files",
    repo: "git@github.com:peterjm/related-files.git",
    path: PathHelper.home_path("src/related-files"),
    setup_dir: SETUP_DIR,
  ),
  LocalGemInstaller.new(
    name: "test_that",
    repo: "git@github.com:peterjm/test-that.git",
    path: PathHelper.home_path("src/test-that"),
    setup_dir: SETUP_DIR,
  ),
]

def reminder(key, message)
  marker = File.join(SETUP_DIR, key)
  return if File.exist?(marker)

  puts "\n[setup] #{message}"
  puts "        To suppress this reminder: touch #{marker}"
end

task default: %i[
  install_system_packages
  install_git_freeze
  install_latest_ruby
  gitconfig
  link
  install_nvim_plugins
  update_local_gems
  setup_ssh_key
  reminders
]

task clean: %i[
  uninstall_git_freeze
  delete_nvim_plugins
  unlink
]

task :setup_ssh_key do
  key_path = PathHelper.home_path(".ssh/id_ed25519")
  if File.exist?(key_path)
    puts "SSH key already exists at #{key_path}"
  else
    sh "ssh-keygen -t ed25519 -f #{key_path} -N ''"
    puts "\nSSH key generated. Add it to GitHub with:"
    puts "  gh ssh-key add #{key_path}.pub"
  end
end

task :install_system_packages do
  sh "brew bundle --file=Brewfile"
end

task :reminders do
  FileUtils.mkdir_p(SETUP_DIR)
  reminder "nerd_font", "Set your terminal font to 'MesloLGS Nerd Font' in Terminal > Settings > Profiles > Font"
end

task update_local_gems: LOCAL_GEMS.map { |gem| "update_#{gem.name}" }

LOCAL_GEMS.each do |gem|
  task "update_#{gem.name}" do
    gem.update
  end
end

task :install_nvim_plugins do
  sh 'nvim --headless "+Lazy! sync" +qa'
end

task :delete_nvim_plugins do
  rm_rf PathHelper.home_path(".local/share/nvim/lazy")
end

task :install_latest_ruby do
  installed_rubies = Dir.glob(PathHelper.home_path(".rubies/*"))
  if installed_rubies.any?
    puts "Ruby already installed: #{File.basename(installed_rubies.last)}"
  else
    sh "ruby-install ruby --no-reinstall"
  end
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
