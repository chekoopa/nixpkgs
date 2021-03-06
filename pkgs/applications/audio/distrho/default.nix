{ stdenv, fetchFromGitHub, alsaLib, fftwSinglePrec, freetype, libjack2
, pkgconfig, ladspa-sdk, premake3
, libX11, libXcomposite, libXcursor, libXext, libXinerama, libXrender
}:

let
  premakeos = if stdenv.hostPlatform.isDarwin then "osx"
              else if stdenv.hostPlatform.isWindows then "mingw"
              else "linux";
in stdenv.mkDerivation rec {
  pname = "distrho-ports";
  version = "unstable-2019-10-09";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = "7e62235e809e59770d0d91d2c48c3f50ce7c027a";
    sha256 = "10hpsjcmk0cgcsic9r1wxyja9x6q9wb8w8254dlrnzyswl54r1f8";
  };

  configurePhase = ''
    runHook preConfigure

    sh ./scripts/premake-update.sh ${premakeos}

    runHook postConfigure
  '';

  postPatch = ''
    sed -e "s#@./scripts#sh scripts#" -i Makefile
  '';

  nativeBuildInputs = [ pkgconfig premake3 ];
  buildInputs = [
    alsaLib fftwSinglePrec freetype libjack2
    libX11 libXcomposite libXcursor libXext
    libXinerama libXrender ladspa-sdk
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "http://distrho.sourceforge.net";
    description = "A collection of cross-platform audio effects and plugins";
    longDescription = ''
      Includes:
      Dexed drowaudio-distortion drowaudio-distortionshaper drowaudio-flanger
      drowaudio-reverb drowaudio-tremolo drumsynth EasySSP eqinox HiReSam
      JuceDemoPlugin KlangFalter LUFSMeter LUFSMeterMulti Luftikus Obxd
      PitchedDelay ReFine StereoSourceSeparation TAL-Dub-3 TAL-Filter
      TAL-Filter-2 TAL-NoiseMaker TAL-Reverb TAL-Reverb-2 TAL-Reverb-3
      TAL-Vocoder-2 TheFunction ThePilgrim Vex Wolpertinger
    '';
    license = with licenses; [ gpl2 gpl3 gpl2Plus lgpl3 mit ];
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "x86_64-linux" ];
  };
}
