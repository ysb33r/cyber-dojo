#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class DummyTestRunnerTests < CyberDojoTestBase

  test 'runnable? is false' do
    assert !DummyTestRunner.new.runnable?('kermit-the-frog')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'run tells you how to use HostTestRunner' do
    output = DummyTestRunner.new.run(nil,nil,nil)
    assert output.include?('$ export CYBERDOJO_USE_HOST=true')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) unaffected when output < 50K' do
    less = 'x'*(10*1024)
    output = DummyTestRunner.new.limited(less,50*1024)
    assert_equal output, less
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) unaffected when output = 50K' do
    max_length = 50 * 1024
    longest = 'x'*max_length
    output = DummyTestRunner.new.limited(longest,max_length)
    assert_equal output, longest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) truncated when output > 50K' do
    max_length = 50*1024
    too_long = 'x'*max_length + 'yyy'
    output = DummyTestRunner.new.limited(too_long, max_length)
    expected = 'x'*max_length + "\n" +
               "output truncated by cyber-dojo server"
    assert_equal expected, output
  end

end
