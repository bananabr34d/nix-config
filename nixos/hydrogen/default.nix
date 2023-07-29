# Motherboard: Unsure hydrogen
# CPU:         AMD Ryzen 9 5900HX with Radeon Graphics
# GPU:         AMD Cezanne [Radeon Vega Series / Radeon Mobile Series]
# RAM:         32GB DDR4
# NVME:        512GB Crucial CT500P3PSSD8
# NVME:        
# Storage:     
# SATA:        
# SATA:        

{ inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    (import ./disks.nix { })
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/pipewire.nix
    ../_mixins/services/tailscale.nix
    ../_mixins/virt
  ];

  swapDevices = [{
    device = "/swap";
    size = 2048;
  }];

  boot = {
    blacklistedKernelModules = lib.mkDefault [ "nouveau" ];
    initrd.availableKernelModules = [ "ahci" "nvme" "uas" "usbhid" "sd_mod" "xhci_pci" ];
    kernelModules = [ "amdgpu" "kvm-intel" "nvidia" ];
    kernelPackages = pkgs.linuxPackages_6_3;
  };

  environment.systemPackages = with pkgs; [
    nvtop
  ];

  hardware = {
    mwProCapture.enable = true;
    nvidia = {
      prime = {
        amdgpuBusId = "PCI:3:0:0";
        nvidiaBusId = "PCI:4:0:0";
        # Make the Radeon RX6800 default. The NVIDIA T600 is for CUDA/NVENC
        reverseSync.enable = true;
      };
      nvidiaSettings = false;
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "intel";
      package = pkgs.openrgb-with-all-plugins;
    };
    xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
