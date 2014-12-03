#!/usr/bin/env ruby

require_relative 'model_test_base'

class SandboxTests < ModelTestBase

  test 'path(avatar)' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    sandbox = avatar.sandbox
    assert path_ends_in_slash?(sandbox)
    assert !path_has_adjacent_separators?(sandbox)
    assert sandbox.path.include?('sandbox')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar's sandbox == sandbox's avatar" do
    kata = @dojo.katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    assert_equal avatar, sandbox.avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir is not created until file is saved' do
    kata = @dojo.katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    assert !sandbox.dir.exists?
    sandbox.write('filename', 'content')
    assert sandbox.dir.exists?
  end

end
