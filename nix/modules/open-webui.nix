{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.services.open-webui.enable = lib.mkEnableOption "Open WebUI";
  config = lib.mkIf config.services.open-webui.enable {
    home.packages = [ pkgs.open-webui ];
    launchd.user.agents.open-webui.serviceConfig = {
      ProgramArguments = [ "${pkgs.open-webui}/bin/open-webui" ];
      EnvironmentVariables.OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
