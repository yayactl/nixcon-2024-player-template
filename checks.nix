{ nixpkgs, self }:
{
  x86_64-linux = import ./tests {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    runTest = nixpkgs.lib.nixos.runTest;
    flake = self;
  };
}
