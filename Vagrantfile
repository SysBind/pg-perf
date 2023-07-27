# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

machines = {
  "postgres" => {:vbox => "debian/bullseye64", :cpus => 2, :mem => 8000, :provision => "./install-postgres-db.sh"},
  "alloy" => {:vbox => "debian/bullseye64", :cpus => 2, :mem => 8000, :provision => "./install-alloy-db.sh"},
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  machines.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|
      cfg.vm.provider :libvirt do |libvirt|
        # disable NFS shared folder
        config.vm.synced_folder '.', '/vagrant', disabled: true
        config.nfs.verify_installed = false
        #libvirt.qemu_use_session = false
        cfg.vm.box = info[:vbox]
        libvirt.cpus = info[:cpus]
        libvirt.memory = info[:mem]
        cfg.vm.provision "install", type: "shell", path: info[:provision]
      end
    end # end provider - libvirt
  end # end config
end

