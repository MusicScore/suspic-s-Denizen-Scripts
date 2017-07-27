# FeverDeath Readme
## Contact the Scripter
The easiest way to contact me is via Discord (The_Conductor#3584) or email (grandpartymask@gmail.com). However, it is usually better if you join the Denizen Discord group ( https://discord.gg/Q6pZGSR ) for support regarding his scripts.

To report issues with the script, please use the GitHub repository at https://github.com/MusicScore/Denizen-GrandPartyAddons/issues

## About
Currently only supports 1.11+

Inspired by the indie game "Darkest Dungeon", this addon aims to modify how player death (not mob death!) works in Minecraft.

This addon features three main modules, listed in priority order:
1. Death's Door
2. Afterlife
3. Thanatophobia

#### *Death's Door*
Instead of outright dying, when the player's HP hits 0, the player enters a state called "Death's Door." Once in Death's Door, any damage dealt has a chance of killing the player. If the player can recover 1+ HP (not from saturation), they will enter the recovery phase.

The recovery phase (if enabled) will
* reduce the player's maximum health by 15%
* reduce health received from healing by 10%
* increase damage taken by 10%

If the recovery phase is fully waited out without returning to Death's Door, the above debuffs will be removed.

#### *Afterlife*
The main purpose is to modify player respawning. Custom EXP and item loss can be configured, among other options.

#### *Thanatophobia*
A basic little feature that warns the player of when their health reaches a certain percent based on their maximum health.

## How to Install

Required dependencies:
> 1. Denizen Developemental (plugin)

Optional dependencies:
> 1. none

When installing Denizen, please use the latest DEVELOPMENT version!

Once Denizen has been installed, you WILL need to change an option in the Denizen configuration. Go to /plugins/Denizen/config.yml and find the option

```yaml
Commands:
    ...
    Yaml:
        # Whether the YAML command is allowed to save outside the minecraft folder.
        # Set to 'false' if you're worried about security.
        Allow saving outside folder: false
```
Set the above option to true. Then, go to the folder "/plugins/Denizen/scripts". Extract the FeverDeath archive into that folder. Alternatively, if you downloaded this addon as a single file, simply drag the file to the folder.

If your server is still running, simply use this command to load the addon: `/denizen reload scripts`

After this, you're done! If you wish to access the configuration for FeverDeath, simply go to the folder "/plugins/GrandPartyAddons/FeverDeath".

## Using FeverDeath as a Dependency

To use FeverDeath as a dependency in your own script(s), you really only need to call the options in the configuration. Unlike what versions 0.1 and 0.2 told you, you will have to call these options by yourself.

To help you out, I've included the depreciated prewritten definitions scripts. They are located in the "gpa_feverDeath_def.yml" file, and have a complete list of definitions/tags that should help you.
##
Now, if you wanted to use FeverDeath as a dependency for a plugin (for whatever reason), there's not much I can do to help. For the most part, you'll have to find a way to do it yourself. However, it is possible for a plugin to use FeverDeath as a dependency.

## Commands and Permissions

#### *Commands*
/feverdeath version
> Prints the version of the addon

/feverdeath reload
> Reloads the configuration

#### *Permission*
gpa.feverdeath.admin
> Grants use to the two commands above.

## Bugs, Support, and Editing the FeverDeath Addon

To report bugs and the like, feel free to visit my Discord PM or the Denizen Discord group.
  
For incoming issues, general support questions, and feature requests, refer to this GitHub repository.

When editing the FeverDeath addon, remember that I am not liable for any damage done to your server. The addon itself is always scripted to be as harmless as possible. If your edited version does not react in expected ways, please first find support in the Denizen Discord group before resorting to me.
