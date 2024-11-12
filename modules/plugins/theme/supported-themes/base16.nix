{
  config,
  lib,
  ...
}: let
  cfg = config.vim.theme;
  inherit (lib.strings) hasPrefix;
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.types) hexColor mkPluginSetupOption;
  inherit (lib.nvim.dag) entryBefore;
  inherit (lib.nvim.lua) toLuaObject;

  numbers = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F"];
  base16Options = listToAttrs (map (n: {
      name = "base0${n}";
      value = mkOption {
        description = "The base0${n} color to use";
        type = hexColor;
        apply = v:
          if hasPrefix "#" v
          then v
          else "#${v}";
      };
    })
    numbers);
in {
  base16 = {
    setupOpts = mkPluginSetupOption "base16" base16Options;
    setup = "";
  };
  config =
    mkIf cfg.name
    == "base16" {
      vim = {
        startPlugins = ["base16"];
        luaConfigRC.theme = entryBefore ["pluginConfigs"] ''
          require('base16-colorscheme').setup(${toLuaObject cfg.setupOpts})
        '';
      };
    };
}
