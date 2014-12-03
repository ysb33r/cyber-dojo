#!/usr/bin/env ruby

require_relative 'model_test_base'

class AvatarsTests < ModelTestBase

  test 'there are 16 avatar names' do
    assert_equal 16, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatar names all begin with a different letter' do
    first_letters = Avatars.names.collect{|name| name[0]}.uniq
    assert_equal first_letters.length, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'kata.avatars() returns all avatars started in the kata' do
    kata = make_kata
    cheetah = kata.start_avatar(['cheetah'])
    lion = kata.start_avatar(['lion'])
    assert_equal ['cheetah','lion'], kata.avatars.map{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.katas[id].avatars() returns all avatars started in kata with given id' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    hippo = kata.start_avatar(['hippo'])
    expected_names = [lion.name, hippo.name]
    names = @dojo.katas[kata.id.to_s].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.katas[id].avatars[name] finds avatar with given name' do
    kata = make_kata
    panda = kata.start_avatar(['panda'])
    assert_equal ['panda'], kata.avatars.map{|avatar| avatar.name}
    assert_equal 'panda', @dojo.katas[kata.id.to_s].avatars['panda'].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'avatars.count' do
    kata = make_kata
    assert_equal 0, kata.avatars.count
    kata.start_avatar
    assert_equal 1, kata.avatars.count
    kata.start_avatar
    assert_equal 2, kata.avatars.count
  end

end
