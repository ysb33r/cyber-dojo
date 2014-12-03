#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class FakeDirTests < CyberDojoTestBase

  def setup
    @disk = FakeDisk.new
    @path = 'fake/'
    @dir = FakeDir.new(@disk,@path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'path is as set in ctor' do
    assert_equal @path, @dir.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false before make is called, true after' do
    assert !@dir.exists?
    @dir.make
    assert @dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(filename) is true after write(filename)' do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) raises if no file exists' do
    filename = 'wibble.rb'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "FakeDir['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) returns previous write(filename,content)' do
    filename = 'fable.txt'
    content = 'once upon a time'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) raises if different filename stubbed' do
    @dir.write('wibble.h', '#include <stdio.h>')
    filename = 'wibble.cpp'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "FakeDir['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'each filters nested-sub-folders to immediate sub-folder only' do
    @disk[@path + 'a']
    @disk[@path + 'b']
    @disk[@path + 'b/c']
    assert_equal ['a','b'], @disk['fake'].entries.sort
    assert_equal ['a','b'], @disk['fake/'].entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'write() raises if filename ends in .rb and content is string' do
    assert_raise RuntimeError do
      @dir.write('filename.rb', 'theory')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'write(filename.rb,content) succeeds and can be read back as ruby object' do
    @dir.write('filename.rb', { :answer => 42 })
    assert_equal '{:answer=>42}', @dir.read('filename.rb')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'write() raises if filename ends in .json and content is string' do
    assert_raise RuntimeError do
      @dir.write('filename.json', 'theory')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'write(filename.json,content) succeeds and can be read back as json object' do
    @dir.write('filename.json', { :answer => 42 })
    assert_equal '{"answer":42}', @dir.read('filename.json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'write(filename.txt,content) succeeds and can be read back' do
    @dir.write('filename.txt','hello, world')
    assert_equal 'hello, world', @dir.read('filename.txt')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'lock(block) is executed' do
    called = false
    @dir.lock do
      called = true
    end
    assert called
  end

end
