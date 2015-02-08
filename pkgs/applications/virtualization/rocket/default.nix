{ stdenv, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.3.1";
  name = "rocket-${version}";
  goPackagePath = "github.com/coreos/rocket";
  src = fetchFromGitHub {
    owner = "coreos";
    repo = "rocket";
    rev = "v${version}";
    sha256 = "0qsppv67ibjqg3xvlw93mwvxam748v242rp3c2dcbrgn4nwx1hhv";
  };

  dontInstallSrc = true;

  meta = with stdenv.lib; {
    description = "CLI and runtime for App Containers";
    homepage = https://github.com/coreos/rocket;
    license = licenses.asl20;
    maintainers = with maintainers; [ kragniz ];
    platforms = stdenv.lib.platforms.linux;
  };
}
