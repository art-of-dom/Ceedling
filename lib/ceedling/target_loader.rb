module TargetLoader
  class NoTargets    < RuntimeError; end

  class NoDirectory  < RuntimeError; end

  class NoDefault    < RuntimeError; end

  class NoSuchTarget < RuntimeError; end

  class RequestReload < RuntimeError; end

  def self.inspect(config, target_name = nil)
    raise NoTargets unless config[:targets]

    targets = config[:targets]
    raise NoDirectory, 'No targets directory specified.' unless targets[:targets_directory]
    raise NoDefault, 'No default target specified.' unless targets[:default_target]

    target_path = ->(name) { File.join(targets[:targets_directory], name + '.yml') }

    target = if target_name
               target_path.call(target_name)
             else
               target_path.call(targets[:default_target])
             end

    raise NoSuchTarget, "No such target: #{target}" unless File.exist? target

    ENV['CEEDLING_MAIN_PROJECT_FILE'] = target

    raise RequestReload
  end
end
