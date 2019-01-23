# suspic's Denizen Scripts
Can be referred to as "suscripts" for the humor.

Scripts written in Denizen by me, for public use. This repository (as it should be obvious) is NOT affiliated with mcmonkey (author of Denizen) in any way.

If you wish to contact me, you can find me at the Denizen Discord group. The invite link is https://discord.gg/Q6pZGSR. I will be under the nickname of `suspicbot`.

To find a list of planned script sets, check out the [Planned Script Sets file](PLANNED_SCRIPT_SETS.md).

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
```
**Commands.Log.Allow logging** is recommended to be set to "`true`".

By setting **Commands.Log.Allow logging** to `true`, appropriate configuration files can be generated outside of the Denizen folder and in the `/plugins/suscripts/` folder (for example, ExampleScriptSet would generate a config file with the filepath `/plugins/suscripts/script_set/config.yml`). This is mostly ease of access, but it also serves the purpose of allowing users unfamiliar with Denizen to customize scripts as if it were another Java plugin. Meaning, even with no knowledge of code or dScript any user can edit and configure the way the scripts behave without ever having to touch the scripts or the Denizen folder themselves.

Some of the script sets won't require these options to be set to true. However, some of them do.

## How to Install Script Sets
To install addons from this repository, simply download all of the relevant **YAML** files from the script set(s) you wish to install and move those files to the `/plugins/Denizen/scripts/` directory in your server's directory. For example, to install SuspicUtilities, you will want to download all **YAML** files from this GitHub repository and move those files to `/plugins/Denizen/scripts/`.

More specific information about each addon will be find in the `readme.txt` in each script set's folder.
