class CacheinatorHelper
  constructor :file_wrapper, :yaml_wrapper

  def diff_cached_config?(cached_filepath, hash)
    return false unless @file_wrapper.exist?(cached_filepath)
    return true if @yaml_wrapper.load(cached_filepath) != hash

    false
  end

  def diff_cached_defines?(cached_filepath, files)
    changed_defines = false
    current_defines = COLLECTION_DEFINES_TEST_AND_VENDOR.reject(&:empty?)

    current_dependencies = files.collect { |source| [source, current_defines.dup] }.to_h
    unless @file_wrapper.exist?(cached_filepath)
      @yaml_wrapper.dump(cached_filepath, current_dependencies)
      return changed_defines
    end

    dependencies = @yaml_wrapper.load(cached_filepath)
    common_dependencies = current_dependencies.select { |file, _defines| dependencies.has_key?(file) }

    changed_defines = true if dependencies.values_at(*common_dependencies.keys) != common_dependencies.values

    dependencies.merge!(current_dependencies)
    @yaml_wrapper.dump(cached_filepath, dependencies)

    changed_defines
  end
end
