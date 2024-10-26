{
  description = "NixCon 2024 - NixOS on garnix: Production-grade hosting as a game";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.garnix-lib = {
    url = "github:garnix-io/garnix-lib";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, garnix-lib, flake-utils }:
    let
      system = "x86_64-linux";
    in
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = {
          webserver = import ./webserver.nix { inherit pkgs; };
          default = packages.webserver;
        };
        apps.default = {
          type = "app";
          program = pkgs.lib.getExe (
            pkgs.writeShellApplication {
              name = "start-webserver";
              runtimeEnv = {
                PORT = "8080";
              };
              text = ''
                ${pkgs.lib.getExe packages.webserver}
              '';
            }
          );
        };
      }))
    //
    {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          garnix-lib.nixosModules.garnix
          self.nixosModules.nixcon-garnix-player-module
          ({ pkgs, ... }: {
            playerConfig = {
              # Your github user:
              githubLogin = "yayactl";
              # You only need to change this if you changed the forked repo name.
              githubRepo = "nixcon-2024-player-template";
              # The nix derivation that will be used as the server process. It
              # should open a webserver on port 8080.
              # The port is also provided to the process as the environment variable "PORT".
              webserver = self.packages.${system}.webserver;
              # If you want to log in to your deployed server, put your SSH key
              # here:
              sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7FB2A7Bc8av/LCfHpJyWBJywW6i/NBo+5cxOVIT9lvfnRzAqdRwLHWt8mxFZEI1Xnc0PSgyKUTuLWlOzF54+Ayn26T4G5j1R/hNagxR6v84E6Vwk05ED86KL6uMxjV/JEErhJqLaSYae4AU97V557smi3flpyFnX/vx5nDs1U+LY/6ZRr7Sv/eG810eflnGFfgCSliGtzcyQbxMobHzdigQiTW66gN/8CvYw8XpkpaZmFVjbSubAcO8gYAgQ/X/HN6PwtrAMS9JMmGfhbYX4jqvxmH8a+4RY5bFW9mN9G5z2xzf6tI5GZchZjHW4yD6y3ctECa1zAtUlspIaUjdseYY1wWF33rLxT+kOl1mqf+Kwk+T65C7/SZAxYn3PQK5s4H6IZoHVPd68z2byq+NFCZxFa5Hiykq6DznGPG44gV4ze3AfJY08koaLb26cCeuKoyGq7ak79AWE73Ltz8pk+Cb8vX0OakjRTLvMhfYHahuVt/IYREf4KstTGh9/ODoE= yanis-mammar@nixos";
            };
          })
        ];
      };

      nixosModules.nixcon-garnix-player-module = ./nixcon-garnix-player-module.nix;
      nixosModules.default = self.nixosModules.nixcon-garnix-player-module;

      # Remove before starting the workshop - this is just for development
      checks = import ./checks.nix { inherit nixpkgs self; };
    };
}
