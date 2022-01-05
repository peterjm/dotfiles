class RubyHelper
  include FileUtils::Verbose

  def install_gem(gem_name)
    return if gem_installed?(gem_name)

    sh gem_command,
      "install",
      "--no-document",
      "--bindir",
      PathHelper.home_path("bin"),
      gem_name
  end

  def uninstall_gem(gem_name)
    return unless gem_installed?(gem_name)

    sh gem_command,
      "uninstall",
      "--executable",
      "--bindir",
      PathHelper.home_path("bin"),
      gem_name
  end

  def install_ruby
    return if ruby_installed?

    sh "ruby-install ruby --no-reinstall"
  end

  private

  def gem_installed?(gem_name)
    sh(gem_command, "list", "--silent", "--installed", "\\A#{gem_name}\\z", verbose: false) do |ok, res|
      return ok
    end
  end

  def gem_command
    PathHelper.home_path(".rubies", ruby_version, "bin", "gem")
  end

  def ruby_version
    installed_rubies.last
  end

  def ruby_installed?
    installed_rubies.any?
  end

  def installed_rubies
    Dir.glob(PathHelper.home_path(".rubies/*")).map { |path| File.basename(path) }
  end
end
