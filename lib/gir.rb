require_relative './gir/git.rb'
require 'fileutils'
require 'gitconfigio'

module Gir
  HOME = `echo $GIR_HOME`.chomp
  SSH_KEY = 'ssh_key'
  GIT_CONFIG = '.gitconfig'
  GIT_SSH = 'git_ssh'
  EDITOR = ->{
    which = lambda{|which|
      `which #{which}`.chomp.length > 0 ? which : false
    }
    return which.call(ENV["EDITOR"]) || which.call('vi') || which.call('emacs') ||
           which.call('vim') || which.call('nano') || which.call('cat')
  }.call

  def self.get_gir_home
    unless FileTest.exists? HOME
      puts '-> girc install'
      exit
    end
    HOME
  end
  
  def self.live_user username
    FileTest.exists? user_path username
  end

  def self.script_path script
    "#{HOME}/script/#{script}"
  end
  
  def self.user_path user
    "#{HOME}/user/#{user}"
  end
  
  def self.user_file user,file
    user_path(user + "/#{file}")
  end
  
  def self.has_profile? username
    FileTest.exists?(user_path(username))
  end
  
  def self.install path
    path = File.expand_path(path.sub(/\/$/,''))
    FileUtils.mkdir_p path + '/user'
    FileUtils.mkdir_p path + '/script'
    File.write("#{path}/script/#{GIT_SSH}",<<-EOS)
#!/bin/sh
exec ssh -i $GIT_KEY "$@"
EOS
    File.chmod(0777,"#{path}/script/#{GIT_SSH}")
    print <<-EOS
echo 'eval "$(girc init -)"' >> ~/.bash_profile
echo 'export GIR_HOME=#{path}' >> ~/.bash_profile
EOS
  end
  
  def self.create_gir_user user
    puts "create #{user}'s dir"
    FileUtils.mkdir_p user_path user
    puts "create ssh-key #=>"
    system "ssh-keygen -t rsa -f #{user_file user,SSH_KEY}"
    # create gitconfign
    File.write("#{user_file user,GIT_CONFIG}",<<-EOS)
# #{user}'s gitconfig\n
[user]
    name = #{user}
    mail = #{user}@mail.com
    email = #{user}@mail.com
EOS
    system "#{EDITOR} #{user_file user,GIT_CONFIG}"
  end
  
end
