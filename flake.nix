{
  description = "My Nix-built Docker image with code-server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      muslPkgs = pkgs.pkgsMusl;
    in {
      packages.${system}.default = pkgs.dockerTools.buildImage {
        name = "code-server";
        tag = "nix";
        
        copyToRoot = muslPkgs.buildEnv {
          name = "code-server-root";
          paths = [
            muslPkgs.busybox
            muslPkgs.code-server
          ];
        };

        config = {
          Cmd = [ "${muslPkgs.code-server}/bin/code-server" "--bind-addr" "0.0.0.0:8080" ];
          ExposedPorts = { "8080/tcp" = { }; };
          WorkingDir = "/home/coder";
        };
      };
    };
}
