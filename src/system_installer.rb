class SystemInstaller
  include FileUtils

  class << self
    def current
      if ENV['SPIN']
        AptGetInstaller.new
      elsif !`which brew`.empty?
        BrewInstaller.new
      else
        NoInstaller.new
      end
    end
  end

  def check_and_install(name)
    package_name = system_package_name(name)
    if installed?(package_name)
      puts "#{package_name} already installed"
    else
      install(package_name)
    end
  end

  def system_package_name(name)
    name
  end
end

class NoInstaller < SystemInstaller
  def check_and_install(package_name)
    puts "ERROR: no system installer; couldn't install '#{package_name}'"
  end
end

class BrewInstaller < SystemInstaller
  def installed?(package_name)
    `brew list`.split.include?(package_name)
  end

  def install(package_name)
    sh "brew install #{package_name}"
  end
end

class AptGetInstaller < SystemInstaller
  PACKAGE_NAMES = {
    'the_silver_searcher' => 'silversearcher-ag',
  }

  def installed?(package_name)
    `apt-cache policy #{package_name}` !~ /Installed: \(none\)/
  end

  def install(package_name)
    sh "sudo apt-get install -y #{package_name}"
  end

  def system_package_name(name)
    PACKAGE_NAMES[name] || name
  end
end
