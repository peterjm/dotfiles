require 'pathname'

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

  private

  def system_directories(path = "system")
    SystemDirectories.new(path).directories
  end

  def each_system_file(system_dir)
    return unless File.exist?(system_dir)

    Dir.glob("#{system_dir}/**/**") do |system_file|
      next unless File.file?(system_file) || File.symlink?(system_file)

      relative_file = without_directory(system_file, system_dir)
      dotfile = PathHelper.home_path(dotify(relative_file))

      yield dotfile, system_file
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
    Pathname.new(file).relative_path_from(dir).to_s
  end

  def dotify(path)
    File.join path.split(File::SEPARATOR).map{ |s| s.sub(/^_/, '.') }
  end

  def exists_or_symlinked?(path)
    File.exist?(path) || File.symlink?(path)
  end
end
