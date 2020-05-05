Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'

  config.vm.provider "virtualbox" do |vb|
     vb.memory = '512'
  end  

  config.vm.synced_folder '.', '/vagrant',
    disabled: false,
    type: 'rsync',
    rsync__exclude: [
      '.envrc',
      '.ruby-version',
      '.env',
      './tmp/',
      './bk/'
    ]

  # `wget` command is required on the target host.
  config.vm.provision :shell, inline: <<~BASH
    sudo yum install -y wget
  BASH

  config.vm.provision :mitamae do |mitamae|
    mitamae.root_path = '/vagrant'
    # root_path からの絶対パスで指定する #{root_path}/foo/bar であれば, /foo/bar と指定
    mitamae.recipe = '/sample.rb'
    # root_path からの絶対パスで指定する #{root_path}/baz であれば, /baz と指定
    # mitamae.yaml = '/node.yaml'
    mitamae.bin_path = '/mitamae'
    mitamae.dry_run = ENV['DRY_RUN']
  end
end
