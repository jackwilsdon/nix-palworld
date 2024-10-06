{
  buildFHSEnv,
  palworld-server-unwrapped,
  writeShellScript,
  ...
}:
buildFHSEnv {
  name = "palworld-server";
  inherit (palworld-server-unwrapped) version;

  runScript = writeShellScript "palworld-server.sh" ''
    exec ${palworld-server-unwrapped}/Pal/Binaries/Linux/PalServer-Linux-Shipping "$@"
  '';
  meta.mainProgram = "palworld-server";
}
