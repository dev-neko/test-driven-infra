require 'serverspec'
require 'net/ssh'

set :backend, :ssh

RSpec.configure do |c|
  options = {}
  user    = ""
  host    = ""
  config  = `vagrant ssh-config #{ENV["ROLE"]}`
  config.each_line do |line|
    if match = /HostName (.*)/.match(line)
      host = match[1];
    elsif match = /User (.*)/.match(line)
      user = match[1];
    elsif match = /IdentityFile (.*)/.match(line)
      options[:keys] = [match[1].gsub(/"/, '')]
    elsif match = /Port (.*)/.match(line)
      options[:port] = match[1]
    end
    
  end
  c.ssh = Net::SSH.start(host, user, options)
  c.ssh_options = options # <- *** Important!!
end


=begin
# Original Rakefile
require 'serverspec'
require 'net/ssh'
require 'tempfile'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

`vagrant up #{host}`

config = Tempfile.new('', Dir.tmpdir)
config.write(`vagrant ssh-config #{host}`)
config.close

options = Net::SSH::Config.for(host, [config.path])

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
=end

