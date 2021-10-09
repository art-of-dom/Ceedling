require 'rbconfig'

class SystemWrapper
  # static method for use in defaults
  def self.windows?
    return (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? true : false) if defined?(RbConfig)

    (Config::CONFIG['host_os'] =~ /mswin|mingw/ ? true : false)
  end

  # class method so as to be mockable for tests
  def windows?
    SystemWrapper.windows?
  end

  def module_eval(string)
    Object.module_eval('"' + string + '"')
  end

  def eval(string)
    eval(string)
  end

  def search_paths
    ENV['PATH'].split(File::PATH_SEPARATOR)
  end

  def cmdline_args
    ARGV
  end

  def env_set(name, value)
    ENV[name] = value
  end

  def env_get(name)
    ENV[name]
  end

  def time_now
    Time.now.asctime
  end

  def shell_backticks(command, boom = true)
    retval = `#{command}`.freeze
    $exit_code = $?.exitstatus.freeze if boom
    {
      output: retval.freeze,
      exit_code: $?.exitstatus.freeze
    }
  end

  def shell_system(command, boom = true)
    system(command)
    $exit_code = $?.exitstatus.freeze if boom
    {
      output: ''.freeze,
      exit_code: $?.exitstatus.freeze
    }
  end

  def add_load_path(path)
    $LOAD_PATH.unshift(path)
  end

  def require_file(path)
    require(path)
  end

  def ruby_success
    # We are successful if we've never had an exit code that went boom (either because it's empty or it was 0)
    ($exit_code.nil? || ($exit_code == 0)) && ($!.nil? || ($!.is_a?(SystemExit) && $!.success?))
  end

  def constants_include?(item)
    # forcing to strings provides consistency across Ruby versions
    Object.constants.map { |constant| constant.to_s }.include?(item.to_s)
  end
end
