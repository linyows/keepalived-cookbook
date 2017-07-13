class Chef
  module Keepalived
    class << self
      def outside_conf_file_name(role, name)
        case role.to_sym
        when :vrrp_instance, :check_script, :virtual_server, :vrrp_sync_group
          "#{role}.#{name}.conf"
        else
          "#{name}.conf"
        end
      end
    end
  end

  module Extensions
    module String
      def underscore
        self.gsub('::', '/').
          gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
::String.__send__ :include, Chef::Extensions::String

class Chef
  module Mixin
    module Keepalived
      include Chef::Mixin::ShellOut

      def conf_path
        '/etc/keepalived/keepalived.conf'
      end

      def outside_conf_dir_path
        '/etc/keepalived/conf.d'
      end

      def outside_conf_file_name(name)
        role = self.class.to_s.underscore.split('/').last.gsub('keepalived_', '')
        Chef::Keepalived.outside_conf_file_name(role, name)
      end

      def outside_conf_file_names
        out = shell_out("ls #{outside_conf_dir_path}")
        out.stdout.split("\n") if out.exitstatus.zero?
      end
    end
  end
end
