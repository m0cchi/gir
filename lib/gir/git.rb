module Git
  def self.get_local_repo safe = false
    path = Dir.getwd
    until path == ''
      local = path + '/.git'
      return local if FileTest.exists?  local
      path.sub! /\/((?!\/).)+$/,''
    end
    safe ? Dir.getwd + '/': nil
  end
  
  def self.get_local_repo_dir file = '' ,safe = false
    repo = self.get_local_repo safe
    if repo
      repo.sub! /#{file == '' ? '\/' : ''}\.git$/,''
      repo += file.sub /^\//,''
    end
    repo
  end

end
