class GitConfigurator
  include FileUtils

  def setup
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
    SystemDirectories.new("gitconfigure").directories
      .map { |path| File.join(path, "gitconfig") }
      .select { |file| File.exist?(file) }
  end
end
