{...}: {
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["octavian"];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.dragAndDrop = true;
  boot.kernelParams = ["kvm.enable_virt_at_load=0"];
}
