class SystemInstaller
  include FileUtils::Verbose

  class << self
    def for(package_name)
      if !`which brew`.empty?
        BrewInstaller.new(package_name)
      else
        NoInstaller.new(package_name)
      end
    end
  end

  attr_reader :package_name

  def initialize(package_name)
    @package_name = package_name
  end

  def check_and_install
    if installed?
      puts "#{package_name} already installed"
    else
      install
    end
  end
end

class NoInstaller < SystemInstaller
  def check_and_install
    puts "no system installer available for '#{package_name}'; couldn't install"
  end
end

class BrewInstaller < SystemInstaller
  def installed?
    `brew list`.split.include?(package_name)
  end

  def install
    sh "brew install #{package_name}"
  end
end
