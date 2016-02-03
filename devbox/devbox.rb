require 'erb'

module DevBox

  class VagrantConfiguration

    def self.configure(root, yaml, config)
      self.basic(yaml, config)

      self.apt_update(config)
      self.timezone(yaml, config)
      self.vbox_guest_additions(root, config)

      self.samba(root, yaml, config)

      self.folders(yaml, config)
      self.git_setup(yaml, config)

      self.maven(root, yaml, config)
      self.gradle(yaml, config)
      self.docker(config)

      self.projects(root, yaml, config)
    end

    def self.docker(config)
      config.vm.provision 'docker'
    end

    def self.basic(yaml, config)
      config.vm.hostname = yaml.get('vm.hostname', 'devbox')

      config.vm.provider 'virtualbox' do |vb|
        vb.memory = yaml.get('vm.memory')
        vb.cpus = yaml.get('vm.cpus')
      end

      config.vm.box = yaml.get('vm.box', 'debian/jessie64')
      config.vm.box_check_update = yaml.get('vm.box_check_update', false)

      config.vm.synced_folder '.', '/vagrant', disabled: true

      config.vm.network :private_network, ip: yaml.get('vm.ip', '192.168.1.2')

      config.vm.provision :shell do |shell|
        shell.inline = 'touch $1 && chmod 0440 $1 && echo $2 > $1'
        shell.args = '/etc/sudoers.d/root_ssh_agent "Defaults env_keep += \"SSH_AUTH_SOCK\""'
      end

      config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
      config.ssh.forward_agent = true
    end

    def self.apt_update(config)
      config.vm.provision :shell, inline: 'apt-get update && apt-get upgrade -y'
    end

    def self.timezone(yaml, config)
      config.vm.provision :shell, :inline => 'echo ' + "\""  + yaml.get('vm.timezone', 'Europe/Prague') + "\"" + ' > /etc/timezone'
      config.vm.provision :shell, :inline => 'dpkg-reconfigure --frontend noninteractive tzdata'
    end

    def self.vbox_guest_additions(root, config)
      config.vm.provision :shell, inline: 'apt-get install -y build-essential linux-headers-$(uname -r)'
      config.vm.provision :shell, path: root + File::SEPARATOR + 'devbox/scripts/vbga.sh'
    end

    def self.samba(root, yaml, config)
      template = ERB.new File.new(root + File::SEPARATOR + 'devbox/scripts/smb.conf.erb').read, nil, '%'
      result = template.result(binding)

      config.vm.provision :shell, inline: 'apt-get install -y samba'
      config.vm.provision :shell, inline: "printf \"" + result + "\" > /etc/samba/smb.conf"
      config.vm.provision :shell, inline: 'mkdir -pv $1', args: yaml.get('samba.share.path', '/mnt/share')
      config.vm.provision :shell, inline: 'chown -R $1:$2 $3', args: "\"" + yaml.get('samba.share.user', 'vagrant') + "\" \"" + yaml.get('samba.share.group', 'vagrant') + "\" \"" + yaml.get('samba.share.path', '/mnt/share') + "\""
      config.vm.provision :shell, inline: 'service smbd restart'
      config.vm.provision :shell, inline: 'service nmbd restart'
    end

    def self.folders(yaml, config)
      list = yaml.get('home.folders', [])
      list.each{ |folder|
        if folder['target'].nil?
          config.vm.provision :shell, inline: '/bin/sh -c "mkdir -pv $1"', args: "\"" + folder['path'] + "\"", privileged: false
        else
          config.vm.provision :shell, inline: '/bin/sh -c "ln -fnvs $1 $2"', args: "\"" + folder['target'] + "\" \"" + folder['path'] + "\"", privileged: false
        end
      }
    end

    def self.git_setup(yaml, config)
      config.vm.provision :shell, inline: 'apt-get install -y git'
      list = yaml.get('git', [])

      list.each{ |key, value|
        unless value.nil?
          config.vm.provision :shell, inline: 'git config --global ' + key + ' "' + value + '"', privileged: false
        end
      }
    end

    def self.maven(root, yaml, config)
      template = ERB.new File.new(root + File::SEPARATOR + 'devbox/scripts/maven.xml.erb').read, nil, '%'
      result = template.result(binding)

      script = "#!/bin/sh\ncat > ~/.m2/settings.xml << END\n" + result + "\nEND"
      config.vm.provision :shell, inline: script, privileged: false
    end

    def self.gradle(yaml, config)
      props = self.flatten_hash(yaml.get('gradle', {}))
      result = ''
      props.each_slice(2) { |pair| result += pair[0] + '=' + pair[1] + "\n" }

      script = "#!/bin/sh\ncat > ~/.gradle/gradle.properties << END\n" + result + 'END'
      config.vm.provision :shell, inline: script, privileged: false
    end

    def self.projects(root, yaml, config)
      projects = yaml.get('projects', {})
      projects.each { |project|
        args_list = []
        args_list.push(project['url'])
        args_list.push(project['path'])
        unless project['branch'].nil?
          args_list.push(project['branch'])
        end

        config.vm.provision :shell, path: root + File::SEPARATOR + 'devbox/scripts/clone-project.sh',
          args: args_list, privileged: false
      }
    end

    def self.flatten_hash(my_hash, parent=[])
      my_hash.flat_map do |key, value|
        case value
          when Hash then flatten_hash( value, parent+[key] )
          else [(parent+[key]).join('.'), value]
        end
      end
    end
  end
end