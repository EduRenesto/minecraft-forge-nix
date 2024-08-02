{ lib
, stdenv
, fetchurl
, jre_headless
, gnused
, gnutar
}: stdenv.mkDerivation rec {
  version = "1.20.1-47.3.0";
  name = "forge-server-${version}";

  src = fetchurl {
    url = "https://grytuiwswqfo.objectstorage.sa-saopaulo-1.oci.customer-oci.com/n/grytuiwswqfo/b/mc_public/o/rxnl-patotacraft-server-${version}.tar.gz";
    hash = "sha256-4S5OFvMyg4ub6Zl7FMtl7P1iCLd9M6dOZw7Lts7+fug=";
  };

  dontUnpack = true;

  buildPhase = ''
    mkdir -p $out
    ${gnutar}/bin/tar xvf $src -C $out
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
