require 'open3'
require 'open-uri'
require 'fileutils'
require 'json'

module VagrantPlugins
  module Mitamae
    class Provisioner < Vagrant.plugin('2', :provisioner)
      def initialize(machine, config)
        super
        @root_path = config.root_path
        @bin_path = @root_path + config.bin_path
        @recipe = @root_path + config.recipe unless config.recipe.nil?
        @json = @root_path + config.json unless config.json.nil?
        @yaml = @root_path + config.yaml unless config.yaml.nil?
        @shell = config.shell
        @log_level = config.log_level
        @dry_run = config.dry_run
      end

      def provision
        node_yaml = "--node-yaml=#{@yaml} " unless @yaml.nil?
        node_json = "--node-json=#{@json} " unless @json.nil?
        shell = "--shell=#{@shell} " unless @shell.nil?
        run = "sudo #{@bin_path} local " +
              "#{@recipe} " +
              "#{node_yaml}" +
              "#{node_json}" +
              "#{shell}" +
              "--log-level=INFO" 
        run = run + ' --dry-run' if @dry_run
        run_command(run) if download_mitamae(@bin_path)
      end

      private

      def latest_mitamae_url
        r = open('https://api.github.com/repos/itamae-kitchen/mitamae/releases').read
        JSON.parse(r).first['assets'].map do |asset|
          asset['browser_download_url'] if asset['name'] == 'mitamae-x86_64-linux'
        end.compact[0]
      end

      def download_mitamae(bin_path)
        run = "wget --quiet #{latest_mitamae_url} -O #{bin_path}"
        run_command(run)
        run = "chmod 755 #{bin_path}"
        run_command(run)
        true
      end

      # refer to: https://github.com/hashicorp/vagrant/blob/master/plugins/provisioners/shell/provisioner.rb#L67-L81
      def handle_comm(type, data)
        if [:stderr, :stdout].include?(type)
          # Output the data with the proper color based on the stream.
          color = type == :stdout ? :green : :red

          # Clear out the newline since we add one
          data = data.chomp
          return if data.empty?

          options = {}
          options[:color] = color if !config.keep_color

          @machine.ui.detail(data.chomp, options)
        end
      end

      # refer to: https://github.com/hashicorp/vagrant/blob/master/plugins/provisioners/shell/provisioner.rb#L122-L128
      def run_command(cmd)
        machine.communicate.tap do |comm|
          comm.execute(
            cmd,
            sudo: false,
            error_key: :ssh_bad_exit_status_muted
          ) do |type, data|
            handle_comm(type, data)
          end
        end
      end
    end
  end
end
