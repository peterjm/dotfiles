class SystemDirectories
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def directories
    [
      path,
      dropbox_path("dotfiles", path, "common"),
      (dropbox_path("dotfiles", path, computer_name) unless computer_name.nil?),
      (dotfiles_path("per_host_config", path, computer_name) unless computer_name.nil?)
    ].compact
  end

  def computer_name
    spin || prompt_host || hostname
  end

  def spin
    'spin' if ENV['SPIN']
  end

  def prompt_host
    presence(ENV['PROMPT_HOST'])
  end

  def hostname
    presence(`hostname -s`)
  end

  def dropbox_path(*path)
    home_path(File.join("Dropbox", *path))
  end

  def dotfiles_path(*path)
    File.join(File.dirname(__FILE__), "..", *path)
  end

  def presence(string)
    return nil if string.nil?
    string = string.strip
    string.empty? ? nil : string
  end

  def home_path(path)
    File.join ENV['HOME'], path
  end
end
