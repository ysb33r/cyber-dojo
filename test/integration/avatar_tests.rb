require 'Disk'
require 'Git'
require 'Runner'
    Thread.current[:disk] = Disk.new
    Thread.current[:git] = Git.new
    Thread.current[:runner] = Runner.new
    @dojo = Dojo.new(root_path)
    @kata = make_kata(@dojo, 'Ruby-installed-and-working')
    avatar = @kata.start_avatar # tag 0
      :new => [ ]
    run_test(delta, avatar, visible_files)  # tag 1
      :new => [ ]
    }
    run_test(delta, avatar, visible_files)  # tag 2
          "before.keys.include?(#{deleted_filename})"


    avatar = @kata.start_avatar # tag 0
      :new => [ ]
     }
    run_test(delta, avatar, visible_files) # tag 1
      :new => [ ]
    run_test(delta, avatar, visible_files) # tag 2
    actual = avatar.diff_lines(was_tag = 1, now_tag = 2)

    avatar = @kata.start_avatar # tag 0
      :new => [ added_filename ]
    avatar = @kata.start_avatar # tag 0

      :new => [ ]
    }
    run_test(delta, avatar, visible_files)  # tag 1
    visible_files.delete(deleted_filename)
      :new => [ ]
    run_test(delta, avatar, visible_files)  # tag 2
        "-#{content}"
    kata = make_kata(@dojo, language)
    avatar = kata.start_avatar
      :new => [ ]
    }
    visible_files['output'] = output
    avatar.save_visible_files(visible_files)
    avatar = kata[avatar.name]
  end