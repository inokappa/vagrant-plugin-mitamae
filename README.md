# Vagrant Provisioner Plugin for Mitamae 

vagrant-plugin-mitamae is a vagrant plugin that implements [mitamae](https://github.com/itamae-kitchen/mitamae) as a provisioner.

## Installation

Build the gem by running.

```sh
$ rake build
```

Install the plugin by running.

```sh
$ vagrant plugin install path/to/built/gem
```

## Example Usage

Write recipie.

```sh
$ cat << EOF > sample.rb
package 'httpd' do
  action :install
end

service 'httpd' do
  action [:enable, :start]
end
EOF
```

`wget` command is required on the target host.

Next, configure the provisioner in your Vagrantfile.

```ruby
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
    mitamae.sudo = true
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
