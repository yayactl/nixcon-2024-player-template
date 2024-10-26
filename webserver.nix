{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:

pkgs.buildGoModule {
  pname = "webserver";
  version = "v1.0";

  src = ./.;

  subPakcages = [ "main.go" ];

  vendorHash = null;

  doCheck = false;
}
