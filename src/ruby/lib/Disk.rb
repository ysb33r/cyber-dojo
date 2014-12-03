
# including class must provide make_dir()

module Disk # mixin module

  def dirs
    @dirs ||= { }
  end

  def symlink_log
    @symlink_log ||= [ ]
  end

  def dir_separator
    '/'
  end

  def is_dir?(path)
    dirs.any? {|dir,_spy| dir.start_with?(slashed(path))}
  end

  def subdirs_each(root_dir)                                    # spied/
    subs = [ ]
    dirs.each_key{ |dir|                                        # spied/a/b/
      if dir != root_dir.path && dir.start_with?(root_dir.path)
        sub = dir[root_dir.path.length..-1]                     #       a/b
        last = sub.index(dir_separator) - 1
        subs << sub[0..last]                                    #   <<  a
      end
    }
    subs.sort.uniq.each do |dir|
      yield dir if block_given?
    end
  end

  def [](path)
    path = slashed(path)
    dirs[path] ||= make_dir(self, path)
  end

  def symlink(old_name, new_name)
    symlink_log << ['symlink', old_name, new_name]
  end

private

  def slashed(path)
    path[-1] === dir_separator ? path : path + dir_separator
  end

end
