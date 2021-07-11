class CurlDownload
  include FileUtils::Verbose

  attr_reader :url, :dest, :executable

  def initialize(url:, dest:, executable: false)
    @url = url
    @dest = dest
    @executable = executable
  end

  def exists?
    File.exist?(dest)
  end

  def install
    download unless exists?
  end

  def update
    download
  end

  def download
    sh "curl -fLo #{dest} --create-dirs #{url}"
    sh "chmod +x #{dest}" if executable
  end

  def clean
    rm_f dest
  end
end
