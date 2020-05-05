module VagrantPlugins
  module Mitamae
    class Plugin < Vagrant.plugin('2')
      name 'mitamae'
      description <<-DESC
      This plugin executes a mitamae suite against a running Vagrant instance.
      DESC

      config(:mitamae, :provisioner) do
        require_relative 'config'
        Config
      end

      provisioner(:mitamae) do
        require_relative 'provisioner'
        Provisioner
      end
    end
  end
end
