{
  pkgs,
  lib,
  check ? true,
  inputs,
}: let
  modules = [
    ./basic
    ./core  
    ./code  
    ./explorer
    ./find   
    ./statusline
    ./tabline
    ./theme
    ./keys
  ];

  pkgsModule = {config, ...}: {
    config = {
      _module.args.baseModules = modules;
      _module.args.pkgsPath = lib.mkDefault pkgs.path;
      _module.args.pkgs = lib.mkDefault pkgs;
      _module.args.inputs = lib.mkDefault inputs;
      _module.check = check;
    };
  };
in
  modules ++ [pkgsModule]
