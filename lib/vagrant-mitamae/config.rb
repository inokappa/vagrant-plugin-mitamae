module VagrantPlugins
  module Mitamae
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :root_path
      attr_accessor :bin_path
      attr_accessor :json
      attr_accessor :yaml
      attr_accessor :recipe
      attr_accessor :shell
      attr_accessor :log_level
      attr_accessor :dry_run

      def initialize
        super
        @root_path = UNSET_VALUE
        @bin_path = UNSET_VALUE
        @recipe = UNSET_VALUE
        @json    = UNSET_VALUE
        @yaml    = UNSET_VALUE
        @shell   = UNSET_VALUE
        @log_level = UNSET_VALUE
      end

      def finalize!
        @root_path = '/vagrant' if @root_path == UNSET_VALUE
        @bin_path = nil if @mitamae_path == UNSET_VALUE
        @recipe = nil if @recipe == UNSET_VALUE
        @json = nil if @json == UNSET_VALUE
        @yaml = nil if @yaml == UNSET_VALUE
        @shell = nil if @shell == UNSET_VALUE
        @log_level = 'INFO' if @log_level == UNSET_VALUE
        @dry_run = false if @dry_run == UNSET_VALUE
      end
    end
  end
end
