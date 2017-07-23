# Denizen-GrandPartyAddons
Scripts written in Denizen by me, for public use. This repository (as it should be obvious) is NOT affilated with Denizen in any way.

The reason why these are called "GrandPartyAddons" and not "MusicInsaneAddons" is because GrandPartyMask is my Minecraft username. If you wish to contact me, you can find me at the Denizen Discord group. The invite link is https://discord.gg/Q6pZGSR. I will be under the nickname of `MusicInsane / suspic`.

# Pre-installation Notes
Before installing any of these addons, you *must* have the latest version of **Denizen (Developmental)** installed. You can find it using this link: http://ci.citizensnpcs.co/job/Denizen_Developmental/

Once you have Denizen installed, go to your `config.yml` file. Look for this option:
```YAML
Commands:
    ...
    Yaml:
        # Whether the YAML command is allowed to save outside the minecraft folder.
        # Set to 'false' if you're worried about security.
        Allow saving outside folder: false
```
Set this to "`true`" so that the addons can create the appropriate file(s) necessary for users unfamiliar with Denizen to alter values and options without ever having to touch the actual scripts.

# How to Install Addons
To install addons from this repository, simply download all of the relevant **YAML** files from the addon(s) you wish to install and move those files to the folder `/plugins/Denizen/scripts/`. For example, to install FeverDeath, you will want to download the five **YAML** files in the FeverDeath folder that you should be able to see, and move those files to `/plugins/Denizen/scripts/`.

Something optional that you may wish to do is to create a subfolder named `grandpartyaddons` for the addons first. This is merely for organizational purposes, and is not a required step.

#
More specific information about each addon will be find in the `readme.txt` in each addon's folder.
