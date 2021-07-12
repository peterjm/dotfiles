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
      when "fzf"
        FzfInstaller.new
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
end

class FzfInstaller < SystemInstaller
  # apt-get on Spin has a version of fzf that's too old to use with vim
  # Installing manually for now. This can be removed if we can start using apt-get instead.

  def initialize
    super("fzf")
  end

  def installed?
    File.exist?(installed_executable_path)
  end

  def install
    tar_file = "/tmp/fzf.tar.gz"
    CurlDownload.new(
      url: "https://github.com/junegunn/fzf/releases/download/0.27.2/fzf-0.27.2-linux_amd64.tar.gz",
      dest: tar_file
    ).download
    sh("tar -xf #{tar_file}")
    mkdir_p(bin_path)
    mv("fzf", installed_executable_path)
  ensure
    rm(tar_file)
  end

  private

  def bin_path(path = "")
    File.join(ENV['HOME'], "bin", path)
  end

  def installed_executable_path
    bin_path("fzf")
  end
end
