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
...
Tags:
  # How long a tag can parse before force-closing the tag parser engine. Set to 0 to disable tag parse timing entirely.
  Timeout: 10
```
**Commands.Log.Allow logging** must be set to "`true`".
<br>**Commands.Yaml.Allow saving outside folder** must be set to "`true`".
<br>**Tags.Timeout** is recommended to be set to "`0`".

By setting **Commands.Log.Allow logging** and **Commands.Yaml.Allow saving outside folder** to `true`, appropriate configuration files can be generated in the `/plugins/GrandPartyAddons/` folder (for example, GrandPartyUtilities would generate a config file with the filepath `/plugins/GrandPartyUtilities/config.yml`). This is mostly ease of access, but it also serves the purpose of allowing users unfamiliar with Denizen to customize scripts as if it were another Java plugin. Meaning, even with no knowledge of code or dScript any user can edit and configure the way GrandPartyAddon scripts behave without ever having to touch the scripts themselves.

Setting **Tags.Timeout** to `0` is mostly for optimization purposes. According to the Denizen developer, tags will parse faster when this option is `0`. In other words, scripts typically run faster in terms of reading data when **Tags.Timeout** is set to `0`.

## How to Install Addons
To install addons from this repository, simply download all of the relevant **YAML** files from the addon(s) you wish to install and move those files to the `/plugins/Denizen/scripts/` directory in your server's directory. For example, to install GrandPartyUtilities, you will want to download all **YAML** files (ending with `.yml`) from this GitHub repository's `grandPartyUtilities/` directory and move those files to `/plugins/Denizen/scripts/`.

If you choose to download the **ZIP** archives instead, simply extract the compressed archive(s) into the same folder (`/plugins/Denizen/scripts/`). Please note that although the **ZIP** archives will be considered the latest stable release, use of the "latest dev" releases (aka the script files themselves) is highly recommended. The version found in the **ZIP** archives may not always be supported, depending on the addon's `readme.txt` and `changelog.txt`.

More specific information about each addon will be find in the `readme.txt` in each addon's folder.
