class LocalGemInstaller
  include FileUtils::Verbose

  attr_reader :name, :repo, :path, :setup_dir

  def initialize(name:, repo:, path:, setup_dir:)
    @name = name
    @repo = repo
    @path = path
    @setup_dir = setup_dir
  end

  def update
    fetch

    if up_to_date?
      puts "#{name} already up to date (#{current_sha[0..7]})"
      return
    end

    build_and_install
    record_installed_commit
  end

  private

  def fetch
    if Dir.exist?(path)
      sh "cd #{path} && git pull"
    else
      sh "git clone #{repo} #{path}"
    end
  end

  def up_to_date?
    if current_sha == last_installed_sha
      true
    else
      false
    end
  end

  def build_and_install
    Dir.chdir(path) do
      sh "bundle install"
      sh "rake install"
    end
  rescue RuntimeError => e
    raise "#{name} failed to install. You may need to run `rake update_ruby` to install a newer Ruby version.\n#{e.message}"
  end

  def record_installed_commit
    FileUtils.mkdir_p(setup_dir)
    File.write(marker_path, current_sha)
  end

  def current_sha
    @current_sha ||= `cd #{path} && git rev-parse HEAD`.strip
  end

  def last_installed_sha
    File.exist?(marker_path) ? File.read(marker_path).strip : nil
  end

  def marker_path
    File.join(setup_dir, "#{name}_commit")
  end
end
