class Verbosinator
  constructor :configurator

  def should_output?(level)
    (level <= @configurator.project_verbosity)
  end
end
