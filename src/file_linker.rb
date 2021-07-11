class FileLinker
  include FileUtils::Verbose

  def link
    system_directories.each do |system_dir|
      link_system_directory(system_dir)
    end
  end

  def unlink
    system_directories.each do |system_dir|
      unlink_system_directory(system_dir)
    end
  end

  def system_directories(path = "system")
    SystemDirectories.new(path).directories
  end

  def each_system_file(system_dir)
    return unless File.exist?(system_dir)

    Dir.glob("#{system_dir}/**/**") do |systemfile|
      next unless File.file?(systemfile) || File.symlink?(systemfile)

      relative_file = without_directory(systemfile, system_dir)
      dotfile = home_path(dotify(relative_file))
      systemfile = expanded_path(systemfile)

      yield dotfile, systemfile
    end
  end

  def link_system_directory(system_dir)
    each_system_file(system_dir) do |dotfile, systemfile|
      make_directory(File.dirname(dotfile))
      link_file(systemfile, dotfile)
    end
  end

  def unlink_system_directory(system_dir)
    each_system_file(system_dir) do |dotfile, systemfile|
      next unless links_to?(dotfile, systemfile)
      unlink_file(dotfile)

      dir = File.dirname(dotfile)
      remove_directory(dir) if directory_empty?(dir)
    end
  end

  def make_directory(dir)
    mkdir_p(dir) unless exists_or_symlinked?(dir)
  end

  def directory_empty?(dir)
    Dir.entries(dir) == %w[. ..]
  end

  def remove_directory(dir)
    rmdir dir
  end

  def link_file(src, dest)
    if exists_or_symlinked?(dest)
      warn "#{dest} already exists" unless links_to?(dest, src)
    else
      ln_s src, dest
    end
  end

  def links_to?(dest, src)
    File.symlink?(dest) && File.readlink(dest) == src
  end

  def unlink_file(file)
    rm file
  end

  def without_directory(file, dir)
    file =~ /^#{dir}\/(.*)$/ && $1
  end

  def dotify(path)
    File.join path.split(File::SEPARATOR).map{ |s| s.sub(/^_/, '.') }
  end

  def expanded_path(path)
    File.expand_path(path, dotfiles_root)
  end

  def dotfiles_root
    File.expand_path('..', File.dirname(__FILE__))
  end

  def non_existing_filename(base)
    return base unless File.exist?(base)

    suffix = 2
    loop do
      name = [base, suffix].join('.')
      return name unless File.exist?(name)
      suffix += 1
    end
  end

  def has_git_version?(desired_version)
    `git --version`=~ %r{((?:\d+.)*\d+)}
    version_at_least?(desired_version, $1)
  end

  def version_at_least?(desired_version_string, version_string)
    desired_version = desired_version_string.split('.').map(&:to_i)
    version = version_string.split('.').map(&:to_i)
    (version <=> desired_version) >= 0
  end

  def exists_or_symlinked?(path)
    File.exist?(path) || File.symlink?(path)
  end
end
