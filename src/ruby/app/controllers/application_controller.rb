
def require_dependencies(file_names)
  file_names.each{ |file_name| require_dependency file_name}
end

# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones

require_dependencies %w{
  Docker
  TestRunner
    DockerTestRunner
    DummyTestRunner
    HostTestRunner
  Disk
    OsDisk OsDir
  Folders Git
  TimeNow UniqueId
}

require_dependencies %w{
  Approval Chooser Cleaner FileDeltaMaker
  GitDiff GitDiffBuilder GitDiffParser LineSplitter
  MakefileFilter OutputParser TdGapper
}

require_dependencies %w{
  Dojo
  Language Languages
  Exercise Exercises
  Avatar Avatars
  Kata Katas
  Light Sandbox Tag
}

class ApplicationController < ActionController::Base

  protect_from_forgery

  def id
    path = root_path
    path += 'test/cyberdojo/' if ENV['CYBERDOJO_TEST_ROOT_DIR']
    @id ||= Folders::id_complete(path + 'katas/', params[:id]) || ''
  end

  def dojo
    externals = {
      :runner => runner,
      :disk   => disk,
      :git    => git
    }
    @dojo ||= Dojo.new(root_path,externals)
  end

  def katas
    dojo.katas
  end

  def kata
    katas[id]
  end

  def avatars
    kata.avatars
  end

  def avatar_name
	params[:avatar]
  end

  def avatar
    avatars[avatar_name]
  end

  def was_tag
    params['was_tag']
  end

  def now_tag
    params['now_tag']
  end

  def root_path
    Rails.root.to_s + '/'
  end

protected

  def runner
    @runner ||= Thread.current[:runner]
    @runner ||= DockerTestRunner.new if Docker.installed?
    @runner ||= HostTestRunner.new unless ENV['CYBERDOJO_USE_HOST'].nil?
    @runner ||= DummyTestRunner.new
  end

  def disk
    @disk ||= Thread.current[:disk]
    @disk ||= OsDisk.new
  end

  def git
    @git ||= Thread.current[:git]
    @git ||= Git.new
  end

end
