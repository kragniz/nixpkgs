{ stdenv, fetchurl, dpkg, gtk2 }:

stdenv.mkDerivation rec {
  name = "slack-${version}";
  version = "1.2.6";

  #TODO make this get 32 bit deb if required
  src = fetchurl {
    url = "https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/slack-desktop-${version}-amd64.deb";
    sha256 = "0q2pwail5ifkfyskdap0qmsg72kj66d9x1zz7gv528jyarxhx8gp";
  };

  libPath = stdenv.lib.makeLibraryPath [
    gtk2
  ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = "${dpkg}/bin/dpkg-deb -x $src .";

  installPhase = ''
    rm -r usr/share/lintian
    cp -r usr/share $out

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$libPath" \
      "$out/slack/slack"

    mkdir -p "$out/bin"
    ln -s "$out/slack/slack" "$out/bin/slack"
  '';

  meta = with stdenv.lib; {
    description = "Slack desktop client (beta)";
    homepage    = https://slack.com;
    maintainers = with maintainers; [ kragniz ];
    platforms   = platforms.linux;
  };
}
