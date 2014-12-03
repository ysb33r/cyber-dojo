#!/usr/bin/env ruby

require_relative 'model_test_base'

class LightTests < ModelTestBase

  test 'colour is converted to a symbol' do
    light = make_light('red',[2014,2,15,8,54,6],1)
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'colour was once stored as outcome' do
    light = make_light('red',[2014,2,15,8,54,6],1,'outcome')
    assert_equal :red, light.colour
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'time is read as set' do
    year = 2014
    month = 2
    day = 15
    hh = 8
    mm = 54
    ss = 6
    light = make_light('red',[year,month,day,hh,mm,ss],1)
    time = light.time
    assert_equal year, time.year
    assert_equal month, time.month
    assert_equal day, time.day
    assert_equal hh, time.hour
    assert_equal mm, time.min
    assert_equal ss, time.sec
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'number is read as set' do
    number = 7
    light = make_light('red',[2014,2,15,8,54,6],number)
    assert_equal number, light.number
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'to_json' do
    colour = 'red'
    time = [2014,2,15,8,54,6]
    number = 7
    light = make_light(colour,time,number)
    assert_equal({
      'colour' => :red,
      'time' => Time.mktime(*time),
      'number' => number
    }, light.to_json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def dummy_avatar
    Object.new
  end

  def make_light(rgb,time,n, key='colour')
    Light.new(dummy_avatar, {
      key => rgb,
      'time' => time,
      'number' => n
    })
  end

end
