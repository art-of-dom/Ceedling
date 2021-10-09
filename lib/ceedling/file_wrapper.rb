require 'rubygems'
require 'rake' # for FileList
require 'fileutils'
require 'ceedling/constants'

class FileWrapper
  def get_expanded_path(path)
    File.expand_path(path)
  end

  def basename(path, extension = nil)
    return File.basename(path, extension) if extension

    File.basename(path)
  end

  def exist?(filepath)
    return true if filepath == NULL_FILE_PATH

    File.exist?(filepath)
  end

  def directory?(path)
    File.directory?(path)
  end

  def dirname(path)
    File.dirname(path)
  end

  def directory_listing(glob)
    Dir.glob(glob, File::FNM_PATHNAME)
  end

  def rm_f(filepath, options = {})
    FileUtils.rm_f(filepath, **options)
  end

  def rm_r(filepath, _options = {})
    FileUtils.rm_r(filepath, **options = {})
  end

  def cp(source, destination, options = {})
    FileUtils.cp(source, destination, **options)
  end

  def compare(from, to)
    FileUtils.compare_file(from, to)
  end

  def open(filepath, flags, &block)
    File.open(filepath, flags, &block)
  end

  def read(filepath)
    File.read(filepath)
  end

  def touch(filepath, options = {})
    FileUtils.touch(filepath, **options)
  end

  def write(filepath, contents, flags = 'w')
    File.open(filepath, flags) do |file|
      file.write(contents)
    end
  end

  def readlines(filepath)
    File.readlines(filepath)
  end

  def instantiate_file_list(files = [])
    FileList.new(files)
  end

  def mkdir(folder)
    FileUtils.mkdir_p(folder)
  end
end
