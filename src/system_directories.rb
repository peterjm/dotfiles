class SystemDirectories
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def directories
    [
      PathHelper.dotfiles_path(path),
      (PathHelper.dotfiles_path("per_host_config", path, computer_name) unless computer_name.nil?),
      PathHelper.dropbox_path("dotfiles", path, "common"),
      (PathHelper.dropbox_path("dotfiles", path, computer_name) unless computer_name.nil?)
    ].compact
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

  def presence(string)
    return nil if string.nil?
    string = string.strip
    string.empty? ? nil : string
  end
end
