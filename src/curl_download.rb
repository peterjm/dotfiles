class CurlDownload
  include FileUtils

  attr_reader :url, :dest

  def initialize(url:, dest:)
    @url = url
    @dest = dest
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
  end

  def clean
    rm_f dest
  end
end
