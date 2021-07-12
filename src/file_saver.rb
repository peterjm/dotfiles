class FileSaver
  include FileUtils::Verbose

  attr_reader :file, :suffix, :dest, :verbose

  def initialize(file:, suffix:, dest:, verbose: false)
    @file = file
    @suffix = suffix
    @dest = dest
    @verbose = verbose
  end

  def move
    new_name = non_existing_filename(moved_file)
    puts "moved existing #{file} to #{new_name}" if verbose
    mv(file, new_name) if should_be_moved?
  end

  def restore
    mv(moved_file, file) if File.exist?(moved_file)
  end

  private

  def should_be_moved?
    File.exist?(file) && !File.symlink?(file)
  end

  def moved_file
    dest || [file, suffix].join(".")
  end

  def non_existing_filename(base)
    return base unless File.exist?(base)

    version = 2
    loop do
      name = [base, version].join('.')
      return name unless File.exist?(name)
      version += 1
    end
  end
end
