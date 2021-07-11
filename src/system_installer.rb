class SystemInstaller
  include FileUtils::Verbose

  class << self
    def for(package_name)
      if ENV['SPIN']
        spin_installer_for(package_name)
      elsif !`which brew`.empty?
        BrewInstaller.new(package_name)
      else
        NoInstaller.new(package_name)
      end
    end

    def spin_installer_for(package_name)
      case package_name
      when "bash-completion"
        AptGetInstaller.new(package_name)
      when "the_silver_searcher"
        AptGetInstaller.new("silversearcher-ag")
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

class AptGetInstaller < SystemInstaller
  def installed?
    `apt-cache policy #{package_name}` !~ /Installed: \(none\)/
  end

  def install
    sh "sudo apt-get install -y #{package_name}"
  end

  def system_package_name(name)
    PACKAGE_NAMES[name] || name
  end
end
