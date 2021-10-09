class PluginManagerHelper
  def include?(plugins, name)
    include = false
    plugins.each do |plugin|
      if plugin.name == name
        include = true
        break
      end
    end
    include
  end

  def instantiate_plugin_script(plugin, _system_objects, _name)
    eval("#{plugin}.new(system_objects, name)")
  end
end
