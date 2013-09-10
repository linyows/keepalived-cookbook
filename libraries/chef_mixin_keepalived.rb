class Chef
  module Keepalived
    class << self
      def outside_conf_file_name(role, name)
        case role.to_sym
        when :vrrp_instance, :check_script, :virtual_server
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

      def sysctl_path
        '/etc/sysctl.conf'
      end

      def ip_forward_attribute
        'net.ipv4.ip_forward'
      end

      def rp_filter_attribute
        'net.ipv4.conf.default.rp_filter'
      end

      def sysctl(attr)
        path = case attr.to_s
        when 'ip_forward'
          '/proc/sys/net/ipv4/ip_forward'
        when 'rp_filter'
          '/proc/sys/net/ipv4/conf/default/rp_filter'
        end

        cmd = "cat #{path}"
        out = shell_out(cmd)

        if out.exitstatus.zero?
          out.stdout.strip
        else
          Chef::Log.error out
        end
      end

      def change_sysctl(attr, to)
        search = "#\\?#{Regexp.escape attr}\s\\?=\s\\?[01]"
        replace = "#{attr} = #{to}"

        cmd = "sed -i -e 's/#{search}/#{replace}/g' #{sysctl_path}"
        out = shell_out(cmd)

        if out.exitstatus.zero?
          Chef::Log.debug out
        else
          Chef::Log.error out
        end
      end

      def load_sysctl_settings
        out = shell_out 'sysctl -p'

        if out.exitstatus.zero?
          Chef::Log.info 'Sysctl settings was successfully loaded!'
        else
          Chef::Log.error out
        end
      end

      def change_ip_forward_to(forwarding)
        sysctl_changed = false

        if forwarding
          filter_to = 0
          forward_to = 1
        else
          filter_to = 1
          forward_to = 0
        end

        if sysctl(:ip_forward).eql? forward_to.to_s
          Chef::Log.info "Sysctl ip_forward is already \"#{forward_to}\" - nothing to do"
        else
          change_sysctl(ip_forward_attribute, forward_to)
          sysctl_changed = true
        end

        if sysctl(:rp_filter).eql? filter_to.to_s
          Chef::Log.info "Sysctl rp_filter is already \"#{forward_to}\" - nothing to do"
        else
          change_sysctl(rp_filter_attribute, filter_to)
          sysctl_changed = true
        end

        load_sysctl_settings if sysctl_changed
      end
    end
  end
end
