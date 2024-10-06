{ stdenv }:
stdenv.mkDerivation {
  name = "palworld-server-preload";
  src = ./.;
  buildPhase = ''
    runHook preBuild

    gcc -fPIC -shared -o preload.so preload.c -ldl

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    cp preload.so $out

    runHook postInstall
  '';
}
