{
  name = "ume-server-test";
  globalTimeout = 120;
  nodes.server = {pkgs, ...}: {
    imports = [
      ../../../../nixosModules/ume.nix
    ];

    environment.systemPackages = with pkgs; [
      curl
    ];

    services.ume = {
      enable = true;
      environment = {
        # for the love of god please don't use this or else
        # i will have no choice to destroy my computer
        UME_UPLOADER_KEY = "*noticesbulge*owowhatsthis?";
      };
    };
  };

  testScript = builtins.readFile ./testScript.py;
}
