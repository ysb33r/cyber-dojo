
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class ModelTestBase < Test::Unit::TestCase

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  def setup
    external_doubles = {
      :disk   => @disk = SpyDisk.new,
      :git    => @git  = SpyGit.new,
      :runner => StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,external_doubles)
    @max_duration = 15
  end

  def teardown
    @disk.teardown
  end

  def make_kata
    visible_files = {
        'wibble.hpp' => '#include <iostream>',
        'wibble.cpp' => '#include "wibble.hpp"'
    }
    language = @dojo.languages['test-C++-Catch']
    language.dir.spy_read('manifest.json', { :visible_filenames => visible_files.keys })
    visible_files.each {|filename,content| language.dir.spy_read(filename, content) }
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.spy_read('instructions', 'your task...')
    @dojo.katas.create_kata(language, exercise)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(@disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = @disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

  def filenames_written_to(log)
    # each log entry is of the form
    #  [ 'read'/'write',  filename, content ]
    log.select { |entry| entry[0] == 'write' }.collect{ |entry| entry[1] }
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

end
