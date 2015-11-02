# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.berkshelf.enabled = true
  config.vm.hostname = 'flashcards'
  config.vm.box = 'precise64'
  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '2048'
    vb.cpus = 2
  end

  # Forwarded Ports
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell, :path => "provision.sh"

  # Agent forwarding over SSH connections
  config.ssh.forward_agent = true

  # Provisioning
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'git'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rvm::vagrant'
    chef.add_recipe 'rvm::system'
    chef.add_recipe 'rvm::user'
    chef.add_recipe 'nginx'
    chef.json = {
      git: {
        prefix: "/usr/local"
      },
      postgresql: {
        config: {
          listen_addresses: "*",
          port: "5432"
        },
        pg_hba: [
          {
            type: "local",
            db: "flcard_adv_dev",
            user: "flcard",
            addr: nil,
            method: "md5"
          },
          {
            type: "local",
            db: "flcard_adv_test",
            user: "flcard",
            addr: nil,
            method: "md5"
          },
          {
            type: "host",
            db: "all",
            user: "all",
            addr: "0.0.0.0/0",
            method: "md5"
          },
          {
            type: "host",
            db: "all",
            user: "all",
            addr: "::1/0",
            method: "md5"
          }
        ],
        password: {
          postgres: "flcard"
        }
      },
      rvm: {
        user_installs: [
          {
            user: "vagrant",
            default_ruby: "2.0.0",
            rubies: [
              "2.0.0-p643"
            ],
            global: "2.0.0-p643"
          }
        ]
      },
      nginx: {
        dir: "/etc/nginx",
        log_dir: "/var/log/nginx",
        binary: "/usr/sbin/nginx",
        user: "www-data",
        init_style: "runit",
        pid: "/var/run/nginx.pid",
        worker_connections: "1024"
      }
    }
  end
end