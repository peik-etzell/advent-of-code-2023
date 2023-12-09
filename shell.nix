let
  unstable = import
    (fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz")
    { };
in
{ nixpkgs ? import <nixpkgs> { } }:
nixpkgs.mkShell { nativeBuildInputs = [ unstable.zig unstable.zls nixpkgs.gdb ]; }
