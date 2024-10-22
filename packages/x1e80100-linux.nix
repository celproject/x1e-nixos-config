{ lib, fetchFromGitHub, buildLinux, linuxPackagesFor, fetchpatch, fetchurl, ... }:

linuxPackagesFor (buildLinux {
  src = fetchFromGitHub {
    owner = "jhovold";
    repo = "linux";
    rev = "wip/x1e80100-6.12-rc3";  # The specific branch for Lenovo Yoga Slim 7x
    hash = "sha256-kpuzjqcI4YGS+S9OvIUhm6z8xCGMA5h5+JlcHhoEETM=";  # SHA256 hash you just retrieved
  };
  version = "6.12.0-rc3";  # Kernel version matching the branch
  defconfig = "johan_defconfig";  # Config specific to your device

  structuredExtraConfig = with lib.kernel; {
    MAGIC_SYSRQ = yes;
    EC_LENOVO_YOGA_SLIM7X = module;
  };

  kernelPatches = [
    {
      name = "Add Bluetooth support for the Lenovo Yoga Slim 7x";
      patch = fetchpatch {
        url = "https://github.com/hogliux/linux-yoga-7x/commit/9829ac9dd0e827cc62242d8ae8b534e31ffd00bd.patch";
        hash = "sha256-2ZfDkbhriRb+52WNc6wlUKZPp55zKCJgxmkf/3m+m2M=";
      };
    }
    {
      name = "dt-bindings: platform: Add bindings for Lenovo Yoga Slim 7x EC";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-devicetree/20240927185345.3680-1-maccraft123mc@gmail.com/raw";
        hash = "sha256-MHbAUR9KMy/DWOfyJBwW7MoM1FK8JmmNEpEvQ6NXJRU=";
      };
    }
    {
      name = "platform: arm64: Add driver for Lenovo Yoga Slim 7x's EC";
      patch = fetchurl {
        url = "https://lore.kernel.org/platform-driver-x86/20240927185345.3680-2-maccraft123mc@gmail.com/raw";
        hash = "sha256-LL88vnk5xvEcC1WVkV+R8aKW9gg43HHC8ZqwaHscfmg=";
      };
    }
    {
      name = "arm64: dts: qcom: Add EC to Lenovo Yoga Slim 7x";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-arm-msm/20240927185345.3680-3-maccraft123mc@gmail.com/raw";
        hash = "sha256-tnpo07ZPi/3cdiY9h90rf2UgTjr9ZfR1PYRVVQJ2pUQ=";
      };
    }
    {
    name = "drm_panic_qr_code_patch";
    patch = fetchurl {
      url = "https://patchwork.freedesktop.org/patch/618184/raw/";
      hash = "sha256-7eEbN0FsbXO2Phb08MEznU6P15Eb15Ge6kB1is8b240";  # The hash in base32 format
    };
    }
  ];
})
