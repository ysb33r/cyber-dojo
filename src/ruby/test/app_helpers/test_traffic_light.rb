#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class TrafficLightTests < CyberDojoTestBase

  include TrafficLightHelper

  def new_avatar(kata,name)
    Avatar.new(kata,name,externals)
  end

  def externals
    nil
  end

  #- - - - - - - - - - - - - - - -

  test 'tool tip' do
    kata = nil
    avatar = new_avatar(kata,'hippo')
    light = Light.new(avatar, {
      'number' => 2,
      'time' => [2012,5,1,23,20,45],
      'colour' => 'red'
    })
    assert_equal "Click to review hippo&#39;s 1 &harr; 2 diff", tool_tip(light)
  end

  #- - - - - - - - - - - - - - - -

  test 'traffic_light_image' do
    expected = "<img src='/images/traffic_light_red.png'" +
               " alt='red traffic-light'" +
               " width='12'" +
               " height='38'/>"
    color = 'red'
    width = '12'
    height = '38'
    actual = traffic_light_image(color,width,height)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'diff_avatar_image' do
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = new_avatar(kata,'hippo')
    def avatar.lights; [1]*27; end
    expected = "" +
      "<div" +
      " class='diff-traffic-light avatar-image'" +
      " title='Click to review hippo&#39;s current code'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='-1'" +
      " data-now-tag='-1'>" +
      "<img src='/images/avatars/hippo.jpg'" +
          " alt='hippo'" +
          " width='45'" +
          " height='45'/>" +
        "</div>"
    actual = diff_avatar_image(avatar)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'diff_traffic_light' do
    # light[:colour] used to be light[:outcome]
    diff_traffic_light_func({'colour' => 'red'})
    diff_traffic_light_func({'outcome' => 'red'})
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def diff_traffic_light_func(light)
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = new_avatar(kata,'hippo')
    def avatar.lights; [1]*7; end
    light = Light.new(avatar, {
      'number' => 3,
      'colour' => 'red'
    })
    expected = "" +
      "<div" +
      " class='diff-traffic-light'" +
      " title='Click to review hippo&#39;s 2 &harr; 3 diff'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='2'" +
      " data-now-tag='3'>" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='17'" +
          " height='54'/>" +
      "</div>"
    actual = diff_traffic_light(light)
    assert_equal expected, actual
  end

end
