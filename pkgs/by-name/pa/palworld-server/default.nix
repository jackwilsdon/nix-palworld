{
  buildFHSEnv,
  callPackage,
  palworld-server-unwrapped,
  writeShellScript,
  ...
}:
let
  preload = callPackage ./preload { };
in
buildFHSEnv {
  name = "palworld-server";
  inherit (palworld-server-unwrapped) version;

  runScript = writeShellScript "palworld-server.sh" ''
    LD_PRELOAD=${preload} ${palworld-server-unwrapped}/Pal/Binaries/Linux/PalServer-Linux-Shipping "$@"
  '';
  meta.mainProgram = "palworld-server";
}
