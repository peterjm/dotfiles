class SystemInstaller
  include FileUtils::Verbose

  class << self
    def for(package_name)
      if ENV['SPIN']
        AptGetInstaller.new(package_name)
      elsif !`which brew`.empty?
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
    puts "ERROR: no system installer; couldn't install '#{package_name}'"
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
  PACKAGE_NAMES = {
    'the_silver_searcher' => 'silversearcher-ag',
  }

  def initialize(package_name)
    super(system_package_name(package_name))
  end

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
