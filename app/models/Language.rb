
class Language

  def initialize(dojo, name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo

  def name
    # Some language folders have been renamed.
    # This creates a problem for practice-sessions done
    # before the language-folder rename that you now
    # wish to fork from. Particularly for sessions with
    # well known id's such as the refactoring dojos.
    # So patch to the language new-name.
    case @name
    when 'C'       then return 'C-assert'
    when 'C++'     then return 'C++-assert'
    when 'C#'      then return 'C#-NUnit'
    when 'Erlang'  then return 'Erlang-eunit'
    when 'Haskell' then return 'Haskell-hunit'
    when 'Java'    then return 'Java-JUnit'
    when 'Java-JUnit-Mockito' then return 'Java-Mockito'
    when 'Perl'    then return 'Perl-TestSimple'
    when 'Python'  then return 'Python-unittest'
    when 'Ruby'    then return 'Ruby-TestUnit'
    else                return @name
    end

    # Still to build docker image
    # when 'Clojure'      then return 'Clojure-.test'
    # when 'CoffeeScript' then return 'CoffeeScript-jasmine'
    # when 'Go'           then return 'Go-testing'
    # when 'Javascript'   then return 'Javascript-node'
    # when 'PHP'          then return 'PHP-PHPUnit'
    #
    # Ok but no docker image yet...
    #"C++-Catch"            --> C++-Catch
  end

  def exists?
    paas.exists?(self)
  end

  def runnable?
    paas.runnable?(self)
  end

  def display_name
    manifest['display_name'] || @name
  end

  def display_test_name
    manifest['display_test_name'] || unit_test_framework
  end

  def image_name
    manifest['image_name'] || ""
  end

  def visible_files
    Hash[visible_filenames.collect{ |filename|
      [ filename, read(filename) ]
    }]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
  end

  def lowlight_filenames
    # Catering for two uses
    # 1. carefully constructed set of start files (like James Grenning uses)
    #    with explicitly set highlight_filenames entry in manifest
    # 2. default set of files direct from languages/
    #    viz, no highlight_filenames entry in manifest
    if highlight_filenames.length > 0
      return visible_filenames - highlight_filenames
    else
      return ['cyber-dojo.sh', 'makefile']
    end
  end

  def unit_test_framework
    manifest['unit_test_framework']
  end

  def tab
    " " * tab_size
  end

  def tab_size
    manifest['tab_size'] || 4
  end

  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    begin
      @manifest ||= JSON.parse(read('manifest.json'))
    rescue
      raise "JSON.parse('manifest.json') exception from language:" + name
    end
  end

private

  def read(filename)
    raw = paas.read(self, filename)
    raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def paas
    dojo.paas
  end

end
