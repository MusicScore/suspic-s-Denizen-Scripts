# Denizen-GrandPartyAddons
Scripts written in Denizen by me, for public use. This repository (as it should be obvious) is NOT affiliated with mcmonkey (author of Denizen) in any way.

If you wish to contact me, you can find me at the Denizen Discord group. The invite link is https://discord.gg/Q6pZGSR. I will be under the nickname of `suspic`.

To find a list of planned addons, check out the [Planned Addons file](PLANNED_ADDONS.md).

## Pre-installation Notes
Before installing any of these addons, you *must* have the latest version of **Denizen (Developmental)** installed. You can find it using this link: http://ci.citizensnpcs.co/job/Denizen_Developmental/

Once you have Denizen installed, go to your `/plugins/Denizen/config.yml` file. Look for these options:
```YAML
Commands:
    ...
    Log:
        # The log command writes to file, which is potentially dangerous
        # Set to 'false' if you're worried about security.
        Allow logging: true
    Yaml:
        # Whether the YAML command is allowed to save outside the minecraft folder.
        # Set to 'false' if you're worried about security.
        Allow saving outside folder: false
```
**Commands.Log.Allow logging** is recommended to be set to "`true`".
<br>**Commands.Yaml.Allow saving outside folder** is recommended to be set to "`true`".

By setting **Commands.Log.Allow logging** and **Commands.Yaml.Allow saving outside folder** to `true`, appropriate configuration files can be generated outside of the Denizen folder and in the `/plugins/GrandPartyAddons/` folder (for example, ExampleGrandAddon would generate a config file with the filepath `/plugins/ExampleGrandAddon/config.yml`). This is mostly ease of access, but it also serves the purpose of allowing users unfamiliar with Denizen to customize scripts as if it were another Java plugin. Meaning, even with no knowledge of code or dScript any user can edit and configure the way GrandPartyAddon scripts behave without ever having to touch the scripts themselves.

Some of the addons won't require these options to be set to true. However, some of them do.

## How to Install Addons
To install addons from this repository, simply download all of the relevant **YAML** files from the addon(s) you wish to install and move those files to the `/plugins/Denizen/scripts/` directory in your server's directory. For example, to install GrandPartyUtilities, you will want to download all **YAML** files from this GitHub repository and move those files to `/plugins/Denizen/scripts/`.

More specific information about each addon will be find in the `readme.txt` in each addon's folder.
