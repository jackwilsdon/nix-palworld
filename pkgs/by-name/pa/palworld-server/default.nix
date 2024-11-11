{
  buildFHSEnv,
  libredirect,
  palworld-server-unwrapped,
  writeShellScript,
  ...
}:
buildFHSEnv {
  name = "palworld-server";
  inherit (palworld-server-unwrapped) version;

  runScript = writeShellScript "palworld-server.sh" ''
    env \
      LD_PRELOAD=${libredirect}/lib/libredirect.so \
      NIX_REDIRECTS=${palworld-server-unwrapped}/Pal/Binaries/Linux/steam_appid.txt=/tmp/steam_appid.txt \
      ${palworld-server-unwrapped}/Pal/Binaries/Linux/PalServer-Linux-Shipping "$@"
  '';
  meta.mainProgram = "palworld-server";
}
