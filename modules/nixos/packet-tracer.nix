{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.packet-tracer;

  ciscoPacketTracer9 = let
    appimage = pkgs.stdenvNoCC.mkDerivation {
      pname = "cisco-packet-tracer-appimage";
      version = "9.0.0";
      src = cfg.debPath;
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
        install -Dm444 ${contents}/CiscoPacketTracer-*.desktop $out/share/applications/cisco-packet-tracer-9.desktop
        install -Dm444 ${contents}/CiscoPacketTracerPtsa-*.desktop $out/share/applications/cisco-packet-tracer-ptsa-9.desktop
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
    packet-tracer.debPath = lib.mkOption {
      type = lib.types.path;
      default = /HDD/CiscoPacketTracer_900_Ubuntu_64bit.deb;
      description = ''
        Path to the Cisco Packet Tracer Ubuntu .deb, downloaded manually from
        NetAcad. Overwrite the file at this path with a newer download and
        rebuild to pick it up — no `nix-store --add-fixed` needed. Reading a
        path outside the flake tree requires building with `--impure`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ciscoPacketTracer9];

    programs.firejail = {
      enable = true;
      wrappedBinaries.packettracer9 = {
        executable = lib.getExe ciscoPacketTracer9;
        desktop = "${ciscoPacketTracer9}/share/applications/cisco-packet-tracer-9.desktop";
        extraArgs = [
          "--net=none"
          "--noprofile"
        ];
      };
    };
  };
}
