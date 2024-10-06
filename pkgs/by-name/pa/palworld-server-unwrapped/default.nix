{
  fetchSteam,
  lib,
  stdenv,
  ...
}:
let
  sdk = fetchSteam {
    name = "steamworks-sdk";
    appId = "1007";
    depotId = "1006";
    manifestId = "7138471031118904166";
    hash = "sha256-OtPI1kAx6+9G09IEr2kYchyvxlPl3rzx/ai/xEVG4oM=";
  };
in
stdenv.mkDerivation {
  name = "palworld-server-unwrapped";
  version = "2024-09-01";

  src = fetchSteam {
    name = "palworld-server";
    appId = "2394010";
    depotId = "2394012";
    manifestId = "7493245879597781625";
    hash = "sha256-NjDdOBfqF4H60u0Y4m/MlplSDDewsdxf6Uj4wPvTntg=";
  };

  installPhase = ''
    cp --no-preserve mode --no-target-directory --recursive . $out
    cp --no-preserve mode ${sdk}/linux64/steamclient.so $out/Pal/Binaries/Linux/steamclient.so

    chmod a+x $out/PalServer.sh $out/Pal/Binaries/Linux/PalServer-Linux-Shipping
  '';

  dontFixup = true;

  meta.license = lib.licenses.unfree;
}
