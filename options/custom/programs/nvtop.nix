{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.custom.programs.nvtop;
in {
  options.custom.programs.nvtop.enable = mkOption {default = false;};

  config.home-manager.users.${config.custom.username} = mkIf cfg.enable {
    # https://github.com/Syllo/nvtop
    #!! Options not available, config written directly
    #?? Imperative config generated by F12
    xdg.configFile."nvtop/interface.ini".text = ''
      [GeneralOption]
      UseColor = true
      UpdateInterval = 3000
      ShowInfoMessages = false

      [HeaderOption]
      UseFahrenheit = false
      EncodeHideTimer = 3.000000e+01

      [ChartOption]
      ReverseChart = false

      [ProcessListOption]
      HideNvtopProcess = true
      SortOrder = descending
      SortBy = gpuRate
      DisplayField = pId
      DisplayField = gpuId
      DisplayField = type
      DisplayField = gpuRate
      DisplayField = encRate
      DisplayField = decRate
      DisplayField = memory
      DisplayField = cpuUsage
      DisplayField = cpuMem
      DisplayField = cmdline

      [Device]
      Pdev = 0000:c1:00.0
      Monitor = true
      ShownInfo = gpuRate
      ShownInfo = gpuMemRate
    '';
  };
}
