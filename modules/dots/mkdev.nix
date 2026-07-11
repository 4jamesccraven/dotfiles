{ inputs, ... }:

/*
  ====[ Mkdev ]====
  :: dotfile

  Enables and configures mkdev, a command line tool for project templates.
*/
{
  home-manager.users.jamescraven = {
    imports = [
      inputs.mkdev.homeManagerModules.default
    ];

    programs.mkdev = {
      enable = true;

      # :> User Config
      config = {
        recipe_dir = "/home/jamescraven/.config/mkdev/recipes";

        subs = {
          # Project
          name = "mk::name";
          dir = "mk::dir";
          # Me
          user = "whoami";
          author = "echo \"James C Craven\"";
          # Time
          day = "date +%d";
          month = "date +%m";
          year = "date +%Y";
        };
      };

      # :> Project Templates
      recipes = import ./mkdev-recipes.nix;
    };
  };
}
