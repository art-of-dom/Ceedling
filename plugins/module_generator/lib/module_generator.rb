require 'ceedling/plugin'
require 'ceedling/constants'
require 'erb'
require 'fileutils'

class ModuleGenerator < Plugin
  attr_reader :config

  def create(module_name, optz = {})
    require 'generate_module' # From Unity Scripts

    if !optz.nil? && (optz[:destroy])
      UnityModuleGenerator.new(divine_options(optz)).destroy(module_name)
    else
      UnityModuleGenerator.new(divine_options(optz)).generate(module_name)
    end
  end

  def stub_from_header(module_name, optz = {})
    require 'cmock' # From CMock
    stuboptz = divine_options(optz)
    pathname = optz[:path_inc] || optz[:path_src] || 'src'
    filename = File.expand_path(optz[:module_root_path], File.join(pathname, module_name + '.h'))
    CMock.new(stuboptz).setup_skeletons(filename)
  end

  private

  def divine_options(optz = {})
    unity_generator_options =
      {
        path_src: (if defined? MODULE_GENERATOR_SOURCE_ROOT
                     MODULE_GENERATOR_SOURCE_ROOT.gsub('\\', '/').sub(%r{^/}, '').sub(
                       %r{/$}, ''
                     )
                   else
                     'src'
                   end),
        path_inc: (if defined? MODULE_GENERATOR_INC_ROOT
                     MODULE_GENERATOR_INC_ROOT.gsub('\\', '/').sub(%r{^/}, '').sub(%r{/$}, '')
                   elsif defined? MODULE_GENERATOR_SOURCE_ROOT
                     MODULE_GENERATOR_SOURCE_ROOT.gsub('\\', '/').sub(%r{^/}, '').sub(
                       %r{/$}, ''
                     )
                   else
                     'src'
                   end),
        path_tst: (if defined? MODULE_GENERATOR_TEST_ROOT
                     MODULE_GENERATOR_TEST_ROOT.gsub('\\', '/').sub(%r{^/}, '').sub(
                       %r{/$}, ''
                     )
                   else
                     'test'
                   end),
        pattern: optz[:pattern],
        test_prefix: ((defined? PROJECT_TEST_FILE_PREFIX) ? PROJECT_TEST_FILE_PREFIX : 'Test'),
        mock_prefix: ((defined? CMOCK_MOCK_PREFIX) ? CMOCK_MOCK_PREFIX : 'Mock'),
        includes: ((defined? MODULE_GENERATOR_INCLUDES) ? MODULE_GENERATOR_INCLUDES : {}),
        boilerplates: ((defined? MODULE_GENERATOR_BOILERPLATES) ? MODULE_GENERATOR_BOILERPLATES : {}),
        naming: ((defined? MODULE_GENERATOR_NAMING) ? MODULE_GENERATOR_NAMING : nil),
        update_svn: ((defined? MODULE_GENERATOR_UPDATE_SVN) ? MODULE_GENERATOR_UPDATE_SVN : false),
        skeleton_path: (if defined? MODULE_GENERATOR_SOURCE_ROOT
                          MODULE_GENERATOR_SOURCE_ROOT.gsub('\\', '/').sub(%r{^/}, '').sub(
                            %r{/$}, ''
                          )
                        else
                          'src'
                        end),
        test_define: ((defined? MODULE_GENERATOR_TEST_DEFINE) ? MODULE_GENERATOR_TEST_DEFINE : 'TEST')
      }

    # Read Boilerplate template file.
    if defined? MODULE_GENERATOR_BOILERPLATE_FILES

      bf = MODULE_GENERATOR_BOILERPLATE_FILES

      unity_generator_options[:boilerplates][:src] = File.read(bf[:src]) if !bf[:src].nil? && File.exist?(bf[:src])

      unity_generator_options[:boilerplates][:inc] = File.read(bf[:inc]) if !bf[:inc].nil? && File.exist?(bf[:inc])

      unity_generator_options[:boilerplates][:tst] = File.read(bf[:tst]) if !bf[:tst].nil? && File.exist?(bf[:tst])
    end

    # If using "create[<module_root>:<module_name>]" option from command line.
    unless optz[:module_root_path].to_s.empty?
      unity_generator_options[:path_src] = File.join(optz[:module_root_path], unity_generator_options[:path_src])
      unity_generator_options[:path_inc] = File.join(optz[:module_root_path], unity_generator_options[:path_inc])
      unity_generator_options[:path_tst] = File.join(optz[:module_root_path], unity_generator_options[:path_tst])
    end

    unity_generator_options
  end
end
