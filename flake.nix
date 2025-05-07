{
  description = "Cross-compile Rust + C (with bindgen) to AArch64 from an x86_64 host";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
  let
    host   = "x86_64-linux";
    target = "aarch64-unknown-linux-gnu";

    # your host pkgs (for clang & bindgen)
    pkgs      = import nixpkgs { system = host; };
    # the cross‐compilation set (targeting AArch64)
    crossPkgs = import nixpkgs {
      system     = host;
      crossSystem = { config = target; };
    };
  in
  {
    packages.x86_64-linux.default = crossPkgs.rustPlatform.buildRustPackage rec {
      pname    = "example";
      version  = "0.1.0";
      src      = self;
      cargoSha256 = "sha256-klW5lUlnKxMWPIwmG03hXaZweRixLShh2F9L3oPz6KY=";
      # ensure there's a Cargo.lock for the vendoring step
      preBuild = ''
        cargo generate-lockfile
      '';

      # tell cargo to build for the AArch64 target
      cargoBuildFlags = [ "--target" target "--release" ];

      # bindgen needs a host clang + libclang
      nativeBuildInputs = [
        pkgs.clang
        pkgs.llvmPackages.libclang
      ];

      # cc crate (inside build.rs) will pick up CC and TARGET env to cross-compile C
      buildInputs = [ crossPkgs.stdenv.cc ];

      # ensure the cross‐compiler and linker are wired up:
      env = {
        CC                                  = crossPkgs.stdenv.cc;
        CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = crossPkgs.stdenv.cc;
        LIBCLANG_PATH                       = pkgs.llvmPackages.libclang.lib;
      };
    };
    devShells.x86_64-linux.shell = pkgs.mkShell {
      buildInputs = [
        pkgs.rustc
        pkgs.cargo
        pkgs.clang
        pkgs.llvmPackages.libclang
      ];
      shellHook = ''
        echo "Shell ready – run 'cargo generate-lockfile' to produce Cargo.lock"
      '';
    };
  };
}
