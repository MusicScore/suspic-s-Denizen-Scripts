################################################################################
#                                                                              #
#                        GRANDPARTYUTILITIES README.TXT                        #
#                                                                              #
################################################################################

+-----------------------------------------------------------------------------|
|  Contact the Scripter                                                       |
+-----------------------------------------------------------------------------|
  
  The easiest way to contact GrandPartyMask is via Discord (The_Conductor#3584)
  or email (grandpartymask@gmail.com). However, it is usually better if you
  join the Denizen Discord group ( https://discord.gg/Q6pZGSR ) for support
  regarding his scripts.
  
  To report issues with the script, please use the GitHub repository at
  https://github.com/MusicScore/Denizen-GrandPartyAddons/issues
  
  
+-----------------------------------------------------------------------------|
|  About                                                                      |
+-----------------------------------------------------------------------------|
  
  Currently supports 1.8.8 to 1.12
  Tested on 1.11.2
  
  GrandPartyUtilities is simply a set of utilities meant to assist with scripts
  in terms of plugin compatibility (such as recording nickname data) and
  general use (such as a version checker script). The main file itself only
  adds the following functions:
  
  - record the player's nickname, prefix, and suffix (separately)
  - send debug from other GrandPartyUtilities scripts
  
  Specific details about each part of GrandPartyUtilities can be found in their
  respective files OR in the config file.
  
  
+-----------------------------------------------------------------------------|
|  How to Install                                                             |
+-----------------------------------------------------------------------------|
  
  Required dependencies:
  - Denizen (plugin)
  Optional dependencies:
  - none
  
  When installing Denizen, please use the latest DEVELOPMENT version!
  
  Once Denizen has been installed, you MAY need to change an option in the
  Denizen configuration. Go to /plugins/Denizen/config.yml and find the option
  
    Commands:
        ...
        Yaml:
            # Whether the YAML command is allowed to save outside the minecraft folder.
            # Set to 'false' if you're worried about security.
            Allow saving outside folder: false
  
  
  If you do not find a folder in your /plugins/ called "GrandPartyAddons", then
  you need to set the above option to true.
  
  Go to the folder "/plugins/Denizen/scripts". Drop any GrandPartyUtilities
  scripts you want into that folder. However, remember that in most cases it is
  recommended to also have "gpa_gpu_main.yml", otherwise you will not be able
  to access certain configurable options without directly editing the scripts.
  
  If your server is still running, simply use this command to load the addon:
    /denizen reload scripts
  
  After this, you're done! If you wish to access the configuration for
  GrandPartyUtilities, simply go to the folder
  "/plugins/GrandPartyAddons/GrandPartyUtilities/".
  
  
+-----------------------------------------------------------------------------|
|  Using GrandPartyUtilities as a Dependency                                  |
+-----------------------------------------------------------------------------|
  
  The main script will be of no use as a dependency.
  
  The Essentials command listener will be of no use as a dependency.
  
  You can use server version checker by using the procedure tag
  "<proc[gpu_versionCheck]>".
  
  
+-----------------------------------------------------------------------------|
|  Commands and Permissions                                                   |
+-----------------------------------------------------------------------------|
  
  COMMANDS:
    /feverdeath version
      - prints the version of the addon
    
    /feverdeath reload
      - reloads the configuration
  
  PERMISSIONS:
    gpa.feverdeath.admin
  
  
+-----------------------------------------------------------------------------|
|  Bugs, Support, and Editing the GrandPartyUtilities Addon                   |
+-----------------------------------------------------------------------------|
  
  Disclaimer: I will never discourage users from editing my scripts. However,
  I will NOT give support for edited copies of GrandPartyUtilities. All scripts
  in the GrandPartyUtilities addon work separately, and use each o
  To report bugs and the like, feel free to visit GrandPartyMask's Discord PM
  or the Denizen Discord group.
  
  For incoming issues, general support questions, and feature requests, refer
  to the GitHub repository for all GrandPartyAddons at:
  https://github.com/MusicScore/Denizen-GrandPartyAddons/issues
  
  When editing the GrandPartyUtilities addon, remember that GrandPartyMask is
  not liable for any damage done to your server. The addon itself is always
  scripted to be as harmless as possible. If your edited version does not react
  in expected ways, please first find support in the Denizen Discord group
  before resorting to GrandPartyMask himself.
  
  