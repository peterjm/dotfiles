class GitConfigurator
  include FileUtils::Verbose

  PERSONAL_SETTINGS = [
    "user.name",
    "user.email",
    "github.user",
  ]

  def setup
    current_gitconfig = "system/_gitconfig"
    tmp_gitconfig = "gitconfig.tmp"

    create_gitconfig_file(tmp_gitconfig)
    if verify_gitconfig_file(tmp_gitconfig)
      finalize_gitconfig_file(tmp_gitconfig, current_gitconfig)
    else
      remove_gitconfig_file(tmp_gitconfig)
    end
  end

  private

  def create_gitconfig_file(filename)
    `touch #{filename}`
    gitconfig_files.each do |file|
      File.read(file).lines.map(&:strip).reject(&:empty?).each do |config_line|
        set_git_config(filename, config_line)
      end
    end
  end

  def verify_gitconfig_file(filename)
    results = PERSONAL_SETTINGS.map { |setting| confirm_git_config_setting(filename, setting) }
    success = results.all?
    warn("create a gitconfig in Dropbox/dotfiles/gitconfigure with system-specific settings") unless success
    success
  end

  def finalize_gitconfig_file(src, dest)
    if !File.exist?(dest)
      mv src, dest
    elsif !system("diff -q #{src} #{dest}")
      system("diff #{dest} #{src}")
      FileSaver.new(file: dest, dest: "gitconfig.old", verbose: true).move
      mv src, dest
    else
      remove_gitconfig_file(src)
    end
  end

  def remove_gitconfig_file(filename)
    `rm #{filename}`
  end

  def set_git_config(filename, setting_and_value)
    `git config -f #{filename} #{setting_and_value}`
  end

  def confirm_git_config_setting(filename, setting)
    system("git config -f #{filename} #{setting} > /dev/null")
  end

  def gitconfig_files
    SystemDirectories.new("gitconfigure").directories
      .map { |path| File.join(path, "gitconfig") }
      .select { |file| File.exist?(file) }
  end
end
