{
  runTest,
  pkgs,
  flake,
}:
{
  basic = runTest {
    name = "basic";
    hostPkgs = pkgs;
    nodes.player =
      { pkgs, ... }:
      {
        imports = [
          flake.inputs.garnix-lib.nixosModules.garnix
          ../module.nix
        ];

        garnix.server.isVM = true;

        playerConfig = {
          sshKey = "ssh-ed25519 SOME KEY";
          webserver = pkgs.writeShellScriptBin "webserver" ''
            set -euo pipefail
            ${pkgs.python3}/bin/python -m http.server $PORT
          '';
        };

      };
    testScript = ''
      player.wait_for_unit("multi-user.target")
      player.wait_for_unit("sshd.service")
      player.wait_for_unit("nginx.service")
      player.wait_for_unit("webserver.service")

      with subtest("Test webserver access"):
        content = player.succeed("curl --fail -s localhost:8080")
        assert "Directory listing for /" in content, content

      with subtest("Test nginx access"):
        content = player.succeed("curl --fail -s localhost")
        assert "Directory listing for /" in content, content
    '';
  };
}
