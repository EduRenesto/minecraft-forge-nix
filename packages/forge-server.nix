{ lib
, stdenv
, fetchurl
, jre_headless
, gnused
}: stdenv.mkDerivation rec {
  version = "1.20.1-47.3.0";
  name = "forge-server-${version}";

  src = fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${version}/forge-${version}-installer.jar";
    hash = "sha256-YBirzpXMBYdo42WGX9fPO9MbXFUyMdr4hdw4X81th1o=";
  };

  dontUnpack = true;

  buildPhase = ''
    mkdir -p $out
    ${jre_headless}/bin/java -jar $src --installServer $out
  '';

  installPhase = ''
    ${gnused}/bin/sed -i "s,libraries/,$out/libraries/,g" $out/libraries/net/minecraftforge/forge/${version}/unix_args.txt
    ${gnused}/bin/sed -i "s,-DlibraryDirectory=libraries,-DlibraryDirectory=$out/libraries,g" $out/libraries/net/minecraftforge/forge/${version}/unix_args.txt

    mkdir -p $out/bin
    cat > $out/bin/minecraft-server <<EOF
      exec ${jre_headless}/bin/java \$@ -DlibraryDirectory="$out/libraries" @$out/libraries/net/minecraftforge/forge/${version}/unix_args.txt nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';
}
