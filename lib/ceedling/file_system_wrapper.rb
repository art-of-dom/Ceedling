class FileSystemWrapper
  def cd(path, &block)
    FileUtils.cd path, &block
  end
end
