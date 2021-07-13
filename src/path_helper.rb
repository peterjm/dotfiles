class PathHelper
  class << self
    def home_root
      ENV['HOME']
    end

    def home_path(*path)
      File.join(home_root, path)
    end

    def dotfiles_root
      File.expand_path('..', File.dirname(__FILE__))
    end

    def dotfiles_path(*path)
      File.join(dotfiles_root, path)
    end

    def dropbox_root
      File.join(home_root, "Dropbox")
    end

    def dropbox_path(*path)
      File.join(dropbox_root, path)
    end
  end
end
