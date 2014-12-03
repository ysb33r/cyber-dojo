#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class GitDiffMostChangedTests < CyberDojoTestBase

  include GitDiff

  #------------------------------------------------------------------

  test 'when current_filename has diffs it is chosen '+
       'even if another file has more changed lines' do
    @current_filename = 'def'
    @diffs = [ ] <<
      diff('abc',22,32) <<
      (@picked=diff(@current_filename,3,1))
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename has diffs it is chosen if ' +
       'another file has equal number of diffs' do
    @current_filename = 'hiker.h'
    @diffs = [ ] <<
      diff('cyber-dojo.sh',0,0) <<
      diff('hiker.c',1,1) <<
      (@picked=diff(@current_filename,1,1)) <<
      diff('hiker.tests.c',0,0)
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename has no diffs it is chosen if ' +
       'it is still exists and no other file has any diffs' do
    @current_filename = 'wibble.cs'
    @diffs = [ ] <<
      diff('abc',0,0) <<
      (@picked=diff(@current_filename,0,0))
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename has no diffs it is still chosen if ' +
       'only other file with diffs is output' do
    @current_filename = 'fubar.cpp'
    @diffs = [ ] <<
      diff('output',2,4) <<
      (@picked=diff(@current_filename,0,0))
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename has no diffs and another non-output file ' +
       'has diffs the current_filename is not chosen' do
    @current_filename = 'def'
    @diffs = [ ] <<
      (@picked=diff('not-output',2,4)) <<
      diff(@current_filename,0,0)
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename is not present and a non output file ' +
       'has diffs then the one with the most diffs is chosen' do
    @current_filename = 'not-present'
    @diffs = [ ] <<
      diff('output',9,8) <<
      diff('wibble.h',2,4) <<
      diff('wibble.c',0,0) <<
      (@picked=diff('instructions',3,4))
    assert_picked
  end

  #------------------------------------------------------------------

  test 'when current_filename is not present and no non-output file ' +
       'has diffs then largest non-output non-instructions file is chosen' do
    @current_filename = nil
    @diffs = [ ] <<
      diff('output',6,8,'13453453534535345345') <<
      diff('wibble.h',0,0,'smaller') <<
      (@picked=diff('wibble.c',0,0,'bit-bigger'))
    assert_picked
  end

  #------------------------------------------------------------------

  def setup
    @n = -1
  end

  def diff(filename,dc,ac,content='')
    @n += 1
    {
      :filename => filename,
      :deleted_line_count => dc,
      :added_line_count => ac,
      :id => 'id_' + @n.to_s,
      :content => content
    }
  end

  def assert_picked
    id = most_changed_file_id(@diffs, @current_filename)
    assert_equal @picked[:id], id
  end

end
