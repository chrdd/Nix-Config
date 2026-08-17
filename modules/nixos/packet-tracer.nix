{
  config,
  lib,
  pkgs,
  ...
}: let
  # nixpkgs' cisco-packet-tracer_9 is pinned to an actual 9.0.0 build.
  # NetAcad currently serves 9.0.1 under the same "_900_" filename, so
  # both the hash and the internal desktop-file names need correcting.
  ciscoPacketTracer9 = let
    appimage = pkgs.stdenvNoCC.mkDerivation {
      pname = "cisco-packet-tracer-appimage";
      version = "9.0.0";
      src = pkgs.requireFile {
        name = "CiscoPacketTracer_900_Ubuntu_64bit.deb";
        hash = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
        url = "https://www.netacad.com/resources/lab-downloads";
      };
      nativeBuildInputs = [pkgs.dpkg];
      installPhase = ''
        runHook preInstall
        cp opt/pt/packettracer.AppImage $out
        runHook postInstall
      '';
    };
  in
    pkgs.appimageTools.wrapType2 rec {
      pname = "cisco-packet-tracer";
      version = "9.0.0";
      src = appimage;
      extraPkgs = _: [pkgs.libpng pkgs.libxkbfile];
      extraBwrapArgs = [
        "--setenv QT_QPA_PLATFORM xcb"
      ];
      extraInstallCommands = let
        contents = pkgs.appimageTools.extract {inherit pname version src;};
      in ''
        mv $out/bin/${pname} $out/bin/packettracer9
        install -Dm444 ${contents}/CiscoPacketTracer-9.0.1.desktop $out/share/applications/cisco-packet-tracer-9.desktop
        install -Dm444 ${contents}/CiscoPacketTracerPtsa-9.0.1.desktop $out/share/applications/cisco-packet-tracer-ptsa-9.desktop
        substituteInPlace $out/share/applications/* \
          --replace-fail "Exec=@EXEC_PATH@" "Exec=packettracer9" \
          --replace-fail "Icon=app" "Icon=cisco-packet-tracer-9"
        install -Dm444 ${contents}/usr/share/icons/hicolor/48x48/apps/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-9.png
        cp -r ${contents}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/
        for desktop in $out/share/applications/*.desktop; do
          sed -i '/^\[Desktop Entry\]/a StartupWMClass=PacketTracer' "$desktop"
        done
      '';
      meta = {
        description = "Network simulation tool from Cisco";
        homepage = "https://www.netacad.com/courses/packet-tracer";
        license = lib.licenses.unfree;
        mainProgram = "packettracer9";
        platforms = ["x86_64-linux"];
        sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      };
    };
in {
  options = {
    packet-tracer.enable = lib.mkEnableOption "Enables Cisco Packet Tracer";
  };

  config = lib.mkIf config.packet-tracer.enable {
    environment.systemPackages = [
      ciscoPacketTracer9
    ];

    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        packettracer9 = {
          executable = lib.getExe ciscoPacketTracer9;
          desktop = "${ciscoPacketTracer9}/share/applications/cisco-packet-tracer-9.desktop";
          extraArgs = [
            "--net=none"
            "--noprofile"
          ];
        };
      };
    };
  };
}
