require 'fileutils'

task :install do
  link_file('gvimrc')
end

def link_file(file)
  dotfile = "~/.#{file}"
  backup_file(dotfile)
  FileUtils.ln_s(file, dotfile)
end

def backup_file(file, ext='local')
  if File.exists?(file)
    backup = "#{file}.#{ext}"
    if File.exists?(backup)
      i = 1
      new_backup = "#{backup}.#{i}"
      while File.exists?(new_backup)
        i += 1
        new_backup = "#{backup}.#{i}"
      end
      backup = new_backup
    end
    FileUtils.mv(file, backup)
  end
end
