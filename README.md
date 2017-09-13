# Denizen-GrandPartyAddons
Scripts written in Denizen by me, for public use. This repository (as it should be obvious) is NOT affiliated with mcmonkey (author of Denizen) in any way.

If you wish to contact me, you can find me at the Denizen Discord group. The invite link is https://discord.gg/Q6pZGSR. I will be under the nickname of `suspic`.

## Pre-installation Notes
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

Not setting this value to `true` will result in the scripts throwing errors regarding file operations in your console and the scripts only using the default values of each configurable option. The errors should not affect gameplay.

## How to Install Addons
To install addons from this repository, simply download all of the relevant **YAML** files from the addon(s) you wish to install and move those files to the `/plugins/Denizen/scripts/` directory in your server's directory. For example, to install GrandPartyUtilities, you will want to download all **YAML** files (ending with `.yml`) from this GitHub repository's `grandPartyUtilities/` directory and move those files to `/plugins/Denizen/scripts/`.

If you choose to download the **ZIP** archives instead, simply extract the compressed archive(s) into the same folder (`/plugins/Denizen/scripts/`). Please note that although the **ZIP** archives will be considered the latest stable release, use of the "latest dev" releases (aka the script files themselves) is highly recommended. The version found in the **ZIP** archives may not always be supported, depending on the addon's `readme.txt` and `changelog.txt`.

##
More specific information about each addon will be find in the `readme.txt` in each addon's folder.
