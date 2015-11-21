VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box     = "CentOS6.7"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/515908/CentOS-6.4-x86.box"

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = "~/.ssh/id_rsa"
    override.vm.box               = "digital_ocean"
    override.vm.box_url           = 
      "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
# We don't need Client_id & API Key for API v2. Use TOKEN instead.
#    provider.crient_id = ENV['DIGITAL_OCEAN_CLIENT_ID']
#    provider.api_key   = ENV['DIGITAL_OCEAN_API_KEY']
    provider.token     = ENV['DIGITAL_OCEAN_TOKEN']
    provider.image     = "centos-6-5-x64"
    provider.region    = "sgp1"
    provider.size      = "512MB"
    provider.ca_path   = "/System/Library/OpenSSL/cert.pem"
    
    if ENV['WERCKER'] == "true"
      provider.ssh_key_name = "wercker"
    else
      provider.ssh_key_name = "Macbook-pro"
    end
  end

  config.vm.provision :shell, inline: <<-EOF
    sudo rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    sudo yum install -y puppet 
  EOF

  config.vm.define :app do |c|
    c.vm.provision :shell do |shell|
      shell.path = "provision.sh"
      shell.args = "app"
    end
  end
end
