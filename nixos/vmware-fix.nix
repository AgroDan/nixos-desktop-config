{ lib, pkgs, ... }:
{
  systemd.mounts = [
    {
      where = "/run/vmblock-fuse";
      what = "${pkgs.open-vm-tools}/bin/vmware-vmblock-fuse";
      type = lib.mkForce "fuse.vmware-vmblock-fuse";
      options = lib.mkForce "subtype=vmware-vmblock,default_permissions,allow_other";
    }
  ];
}
