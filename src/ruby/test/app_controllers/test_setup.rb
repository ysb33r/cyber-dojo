#!/usr/bin/env ruby

require_relative 'controller_test_base'

class SetupControllerTest < ControllerTestBase

  test 'setup uses cached languages and exercises if present' do
    stub_dojo

    languages_dir = @disk[@dojo.languages.path]
    languages_dir.write('cache.json', {
      'fake-C++'  => 'fake-C++-catch',
      'fake-Java' => 'fake-Java-NUnit'
    })

    exercise_dir = @disk[@dojo.exercises.path]
    exercise_dir.write('cache.json', {
      'fake-Print-Diamond'  => 'fake-Print-Diamond instructions',
      'fake-Roman-Numerals' => 'fake-Roman-Numerals instructions'
    })

    get 'setup/show'
    assert_response :success

    assert /data-language\=\"fake-C++/.match(html), "fake-C++"
    assert /data-language\=\"fake-Java/.match(html), "fake-Java"

    assert /data-exercise\=\"fake-Print-Diamond/.match(html), "fake-Print-Diamond"
    assert /data-exercise\=\"fake-Roman-Numerals/.match(html), "fake-Roman-Numerals"
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup/show chooses language and exercise of kata ' +
       'whose 10-char id is passed in URL ' +
       '(to encourage repetition)' do
    stub_dojo

    # setup_languages
    languages_names = [
      'fake-C++',
      'fake-C#',
      'fake-Java',
      'fake-Ruby',
    ].sort

    languages_names.each do |language_name|
      language = @dojo.languages[language_name]
      assert_equal language.name, language.new_name, 'renamed!'
      stub_language(language_name, 'fake-test-framework-name')
    end

    # setup_exercises
    exercises_names = [
      'fake-Print-Diamond',
      'fake-Recently-Used-List',
      'fake-Roman-Numerals',
      'fake-Yatzy',
    ].sort

    exercises_names.each do |exercise_name|
      exercise = @dojo.exercises[exercise_name]
      assert_equal exercise.name, exercise.new_name, 'renamed!'
      stub_exercise(exercise_name)
    end

    language_name = languages_names[2]
    exercise_name = exercises_names[1]
    id = '1234512345'

    stub_kata(id, language_name, exercise_name)

    get 'setup/show', :id => id[0...10]
    assert_response :success

    md = /var selected = \$\('#exercise_' \+ (\d+)/.match(html)
    selected_exercise = exercises_names[md[1].to_i]
    assert_equal exercise_name, selected_exercise, 'exercise'

    md = /var selected = \$\('#language_' \+ (\d+)/.match(html)
    selected_language = languages_names[md[1].to_i]
    assert_equal language_name, selected_language, 'language'

  end

  #- - - - - - - - - - - - - - - - - - -

  # another test to verify language/exercise default
  # to that of kata's id when id is only 6 chars long.
  # This will need disk abstraction in lib/Folders.
  # Or would this be better as a separate test dedicated
  # to just the id completion...

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    create_kata
  end

end
