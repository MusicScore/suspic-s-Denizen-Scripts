####################################################################################################
#                                                                                                  #
#                                   LINEAR CONVERSATION UTILITY                                    #
#                                                                                                  #
####################################################################################################
#                                                                                                  #
# This utility allows people with little to no Denizen experience to create entire linear          #
#   conversations and dynamically load them in. The command provided currently only allows         #
#   reloading conversations from file and running conversation lines automatically.                #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
# -----| PREREQUISITES |-------------------------------------------------------------------------- #
#                                                                                                  #
# In the Denizen config, enable "Commands.Log.Allow logging". This will allow the script to        #
#   generate the example file so you can effectively use the utility.                              #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
# -----| COMMANDS |------------------------------------------------------------------------------- #
#                                                                                                  #
# /lcu help                                                                                        #
#     Displays information about the arguments for the "/gpalcu" command.                          #
#                                                                                                  #
# /lcu reload                                                                                      #
#     Reloads all conversations from file. If no files are found, the example file will            #
#     immediately start generating.                                                                #
#                                                                                                  #
# /lcu run <conversation> (step number) (auto) (player)                                            #
#     Runs a conversation. If this command is run through console, all of the arguments are        #
#       required.                                                                                  #
#     Optionally specify a step number to begin at that step.                                      #
#     Optionally specify whether or not the conversation should automatically run until either     #
#       the next step doesn't exist or the delay for the current step is an invalid number         #
#       of seconds.                                                                                #
#     Optionally specify a player name to display the conversation to that player.                 #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
# -----| PERMISSIONS |---------------------------------------------------------------------------- #
#                                                                                                  #
# linear_conversation_util.cmd                                                                     #
#      Allows use of the "/lcu" command.                                                           #
#      FLAG EQUIVALENT: permission.linear_conversation_util.cmd                                    #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
# -----| HOW TO USE |----------------------------------------------------------------------------- #
#                                                                                                  #
# When your first start your server with this script in it, the example file will automatically    #
#   be created. If you are loading the utility in after the server has started, relax. Just        #
#   reload all Denizen scripts (using the command "/denizen reload scripts") and then run the      #
#   command "/lcu reload".                                                                         #
#                                                                                                  #
# Once the example file has been created, you can go over to the "./plugins/Denizen/configs/       #
#   /linear_conversation_util/" folder and find the "example_conversation.yml" file. It holds a    #
#   very basic conversation with a full explanation of how to create your own conversations.       #
#                                                                                                  #
# Whenever you create or edit conversations and want to load those conversations, just run "/lcu   #
#   reload". All of the conversations will be loaded, and you are ready to trigger them whenever!  #
#                                                                                                  #
# If you are interested in using these scripts in your own scripts, please scroll to the relevant  #
#   scripts and read the comments there.                                                           #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
# -----| RELATED TAGS |--------------------------------------------------------------------------- #
#                                                                                                  #
# <player.flag[linear_conversation_util.<NAME>.step]>                                              #
#     Returns the step number of the specified conversation                                        #
#                                                                                                  #
# <player.flag[linear_conversation_util.<NAME>.queue]>                                             #
#     Returns the queue object of specified conversation                                           #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
####################################################################################################





#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     linear_conversation_handler
#
# [DENIZEN COMMAND SYNTAX]==>
#     - run linear_conversation_handler def:<NAME>|<PATH_NAME>(|<STEP>(|<AUTO>))
#
# [ATTACHED PLAYER/NPC]==>
#     An attached player is required for the script to run.
#     NPCs do not need to be attached to the script.
#
# [DEFINITION ARGUMENTS]==>
#     <NAME>
#         Input: Element
#         Description:
#             Determines which conversation
#
#     <PATH_NAME>
#         Input: Element
#         Description:
#             Determines which path of the conversation to take.
#             Use an asterisk (*) or "none" to use the default path.
#
#     <STEP>
#         Input: Element(Number)
#         Description:
#             Determines the step of the conversation to run. Defaults to 1.
#
#     <AUTO>
#         Input: Element(Boolean)
#         Description:
#             Determines whether to automatically run the conversation, step by step, until the
#             current step has an invalid delay key or the next step does not exist.
#
#             If set to "true", then the queue created by running this task script will be stored
#             in the player flag "<player.flag[linear_conversation_util.<NAME>.queue]>".
#
#
# [DESCRIPTION]==>
#     Forces a player to view a linear conversation. A conversation name must be specified.
#     If no step is specified, then the first step is used.
#     Flags the player with the step number and (if relevant) the queue ID.
#
#     NOTE: Due to the nature of a linear conversation flow, the steps must be only numeric values.
#
# [RELATED TAGS]==>
#     <player.flag[linear_conversation_util.<NAME>.step]>
#         This player flag returns the last step the player was on for a given conversation.
#
#     <player.flag[linear_conversation_util.<NAME>.queue]>
#         This becomes available if the "auto" definition is set to "true".
#
#
# [USAGE EXAMPLES]==>
#     To run only the first step of the example conversation
#         - run linear_conversation_handler def:example_conversation
#
#     To run the full example conversation
#         - run linear_conversation_handler def:example_conversation|1|true
#
#     To run the example conversation from step 3 to the last step
#         - run linear_conversation_handler def:example_conversation|3|true
#
#
#

linear_conversation_handler:
  type: task
  debug: false
  speed: 0
  definitions: name|path|step|auto
  script:
  # Check if player is online
  - if !<player.is_online||false>:
    - debug ERROR "A valid, online PlayerTag must be attached to this script queue!"
    - queue clear

  # Argument checker
  - if <[name]||null>:
    - debug ERROR "Invalid input! The conversation name must not be null!"
    - queue clear

  - define ymldata <server.flag[utility.linear_conversation.loaded.<[name]>]||null>
  - define plfl_prefix linear_conversation_util.conversations.<[name]>

  # Check to see if YAML data for the specified conversation exists
  - if !<yaml.list.contains[<[ymldata]>]>:
    - debug ERROR "The YAML data for <&dq><[name].to_uppercase><&dq> is invalid or does not exist!"
    - narrate "<&c>ERROR! <&f>Conversation unexpectedly ended or could not continue." format:linear_conversation_msgformat
    - flag player <[plfl_prefix]>:!
    - queue clear

  # If the step does not exist, stop
  - if !<yaml[<[ymldata]>].list_keys[<[name]>].contains[<[step]||1>]>:
    - debug ERROR "Invalid step specified for conversation <&dq><[name].to_uppercase><&dq>!"
    - narrate "<&c>ERROR! <&f>Conversation unexpectedly ended or could not continue." format:linear_conversation_msgformat
    - queue clear

  # Interpret and narrate the text
  - define text <parse:<yaml[<[ymldata]>].read[<[key]>.text]||null>>
  - narrate <[text].parse_color[%].replace[\n].with[<&nl>]>

  # Run the assigned task script
  - if <yaml[<[ymldata]>].read[<[key]>.script]||> matches script:
    - run <yaml[<[ymldata]>].read[<[key]>.script]> instantly def:<[name]>|<[step]||1>

  - flag player <[plfl_prefix]>.step:<[step]||1>

  # If the conversation should not continue automatically, if the immediate next step does not
  #   exist, or if the delay is invalid, then the conversation should not continue
  - if !<[auto].as_boolean||false> || !<yaml[<[ymldata]>].contains[<[key]>.<[step].+[1]||2>]> || <yaml[<[ymldata]>].read[<[key]>.delay]||-1> < 0:
    - queue clear

  # Temporarily flag the player with this queue, and wait for the specified delay time
  - flag player <[plfl_prefix]>.queue:<queue>
  - wait <yaml[<[ymldata]>].read[<[key]>.delay]>s
  - flag player <[plfl_prefix]>.queue:!

  - run <script> def:<[name]>|<[step].+[1]||2>|true




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     linear_conversation_cmd
#
# [SPIGOT COMMAND SYNTAX]==>
#     /lcu [help/reload/run] (<name>) (<step>) (<player name>) (true/false)
#
# [COMMAND EXPLANATION]==>
#     /lcu help
#         Displays the Linear Conversation Utility command information.
#
#     /lcu reload
#         Deletes all currently saved data, then loads all conversation data from file.
#
#     /lcu run [<name>] (<step>) (<player name>) (true/{false})
#         Forces a player to viewa a conversation.
#         If no step is specified, then step 1 is used.
#
#         NOTE: If this command is run from console, then every argument except the last one is
#           required.
#
# [PERMISSIONS]==>
#     linear_conversation_util.cmd
#         Grants access to the "/lcu" command. Automatically granted to OP players.
#         FLAG EQUIVALENT: permission.linear_conversation_util.cmd
#
#
# [USAGE EXAMPLES]==>
#   To run only the first step of the example conversation
#     /lcu run example_conversation
#
#   To run the example conversation from step 3 to the last step
#     /lcu run example_conversation 3 suspic_ true
#
#
#

linear_conversation_cmd:
  type: command
  debug: false
  data:
    reg_perm: linear_conversation_util.cmd
    flag_perm: permission.linear_conversation_util.cmd
  name: linearconversationutility
  aliases:
  - linearconversationutil
  - lineconvutil
  - lcu
  description: "Uses the linear conversation utility."
  usage: /lcu [help/reload/run] (<&lt>name<&gt>) (<&lt>step<&gt>) (<&lt>player<&gt>) (true/false)
  allowed help:
  - determine <context.server.OR[<player.is_op>].OR[<player.has_permission[<script.yaml_key[data.reg_perm]>]>].OR[<player.flag[<script.yaml_key[data.flag_perm]>].as_boolean>]>
  tab complete:
  - if <context.server> || <player.is_op> || <player.has_permission[<script.yaml_key[data.reg_perm]>]||false> || <player.flag[<script.yaml_key[data.flag_perm]>].as_boolean>:
    - define s "<context.raw_args.to_list.count[ ]>"

    - choose <[s]>:
      - case 0:
        - determine <list[help|reload|run].filter[starts_with[<context.args.last||>]]>
      - case 1:
        - if <context.args.1||null> == run:
          - determine <server.flag[utility.linear_conversation.loaded_names].filter[starts_with[<context.args.last||>]]||li@>
      - case 2:
        - if <context.args.1||null> == run && <yaml.list.contains[<server.flag[utilities.linear_conversation.loaded.<context.args.2||null>]||null>]>:
          - determine <yaml[<server.flag[utilities.linear_conversation.loaded.<context.args.2>]>].list_keys[<context.args.1||null>].filter[starts_with[<context.args.last||>]]||li@>
      - case 3:
        - if <context.args.1||null> == run:
          - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.last||>]]>
      - case 4:
        - if <context.args.1||null> == run:
          - determine <list[true|false].filter[starts_with[<context.args.last||>]]>

  - determine li@

  script:
  - if !<context.server> && !<player.is_op||false> && !<player.has_permission[<script.yaml_key[data.reg_perm]>]||false> && !<player.flag[<script.yaml_key[data.flag_perm]>].as_boolean>:
    - queue clear

  - if !<script.list_keys[args].contains_text[<context.args.1||null>]>:
    - narrate "<&c>ERROR! <&f>Unknown argument. Try using <&dq>/lcu help<&dq>." format:linear_conversation_msgformat
    - queue clear

  - inject locally args.<context.args.1>

  args:
    help:
    - narrate "===== <&b>Linear Conversation Utility Command Help <&f>=====" format:linear_conversation_msgformat
    - narrate "/lcu help"
    - narrate "<&7>Displays this help page."
    - narrate "/lcu reload"
    - narrate "<&7>Reloads conversations from file(s)."
    - narrate "/lcu run <&lt>name<&gt> (<&lt>step<&gt>) (<&lt>player<&gt>) (true/false)"
    - narrate "<&7>Runs a conversation.
      <&nl>If a step is not specified, step 1 is used.
      <&nl>If the last argument is <&dq>true<&dq>, then the conversation will automatically run from start to finish."

    reload:
    - narrate "Attempting to reload conversations from file(s). Monitor console for any errors." format:linear_conversation_msgformat
    - run linear_conversation_filehandler

    run:
    - if <context.args.2||null> == null:
      - narrate "<&c>ERROR! <&f>A null or invalid conversation cannot be specified!" format:linear_conversation_msgformat
      - queue clear

    - define name <context.args.2||null>
    - define player <server.match_player[<context.args.4||null*>]||<player||null*>>
    - define ymldata <server.flag[utility.linear_conversation.loaded.<[name]>]||null>

    - if !<yaml.list.contains[<[ymldata]>]>:
      - narrate "<&c>ERROR! <&f>The conversation <&dq><[name].to_uppercase><&dq> does not exist!" format:linear_conversation_msgformat
      - queue clear

    - if <context.server> && <[player]> == "null*":
      - narrate "<&c>ERROR! <&f>The player is not specified, valid, nor online!" format:linear_conversation_msgformat
      - queue clear

    - if <player.has_flag[linear_conversation_util.<[name]>.queue]> && <queue.list.contains[<player.flag[linear_conversation_util.<[name]>.queue]||null>]>:
      - queue <player.flag[linear_conversation_util.<[name]>.queue]> clear

    - if <context.server> || <player||null> != <[player]>:
      - narrate "Attempting to run the conversation <&dq><[name].to_uppercase><&dq> at step <&dq><[step]><&dq> for
        <[player].name>. Check console for any errors." format:linear_conversation_msgformat

    - run linear_conversation_handler def:<[name]>|<context.args.3||1>|<context.args.5.as_boolean> player:<[player]>




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     linear_conversation_evts
#
# [DESCRIPTION]==>
#     Loads conversations from file.
#
#
#

ilnear_conversation_evts:
  type: world
  debug: false
  events:
    on server start:
    - run linear_conversation_filehandler




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     linear_conversation_filehandler
#
# [DENIZEN COMMAND SYNTAX]==>
#     - run linear_conversation_filehandler
#
# [DESCRIPTION]==>
#     Reloads all conversation data from file.
#     All automatically run conversations will be immediately stopped.
#
#
#

linear_conversation_filehandler:
  type: task
  debug: false
  speed: 0
  script:
  - announce to_console "Beginning to load files. Please check console for errors..." format:linear_conversation_msgformat

  - ~run locally unload_yaml_data
  - ~run locally validate_directory
  - ~run locally recursive_file_search
  - ~run locally load_files

  - announce to_console "<&a>OKAY! <&f>Loading finished." format:linear_conversation_msgformat

  unload_yaml_data:
  - foreach <server.flag[utility.linear_conversation.loaded_names]||li@> as:name:
    - define id <server.flag[utility.linear_conversation.loaded.<[name]>]>
    - if <yaml[<[id]>].to_json||null> == null:
      - foreach next
    - yaml id:<[id]> unload

  - flag server utility.linear_conversation.loaded_names:!
  - flag server utility.linear_conversation.loaded:!

  validate_directory:
  - if !<server.has_file[./configs/linear_conversation_util/]> || <server.list_files[./configs/linear_conversation_util/].is_empty>:
    - announce to_console "<&c>WARNING! <&f>The <&dq>/plugins/Denizen/configs/linear_conversation_util/<&dq> directory is
      missing or is empty!" format:linear_conversation_msgformat
    - queue clear

  - announce to_console "<&a>OKAY! <&f>Confirmed the existence of the
    <&dq>/plugins/Denizen/configs/linear_conversation_util/<&dq> directory." format:linear_conversation_msgformat

  recursive_file_search:
  - define start_dir <[1]||>
  - define yml_ids li@

  - foreach <server.list_files[./configs/linear_conversation_util/<[start_dir]>]||li@> as:file:
    - if <[file].ends_with[.yml]> || <[file].ends_with[.yaml]>:
      - define uuid <util.random.uuid.replace[-]>
      - announce to_console "<&e>READING... <&f>Found file <[file]>." format:linear_conversation_msgformat
      - flag server utility.linear_conversation.files:->:<[start_dir]><[file]>?linear_conversation_<[uuid]>
      - foreach next
    - if !<server.list_files[./configs/linear_conversation_util/<[start_dir]>].is_empty||true>:
      - ~run locally recursive_file_search def:<[start_dir]><[file]>/

  load_files:
  - if <server.flag[utility.linear_conversation.files].is_empty||true>:
    - announce to_console "<&c>WARNING! <&f>There are no files to load! Is the
      <&dq>/plugins/Denizen/configs/linear_conversation_util/<&dq> directory empty, or is there an issue with the script?"
      format:linear_conversation_msgformat
    - queue clear

  - define conv_list li@

  - foreach <server.flag[utility.linear_conversation.files]> as:file:
    - define id <[file].after[?]>
    - yaml id:<[id]> create
    - yaml id:<[id]> load:/configs/linear_conversation_util/<[file].before[?]>

    - if <yaml[<[file].after[?]>].list_keys[].is_empty||true>:
      - announce to_console "<&c>ERROR! <&f>The file <&dq><[file].before[?]><&dq> is empty!" format:linear_conversation_msgformat
      - yaml id:<[id]> unload
      - foreach next

    - define is_dup_list <yaml[<[id]>].list_keys[].exclude[<yaml[<[id]>].list_keys[].exclude[<[conv_list]>]>]>
    - if !<[is_dup_list].is_empty>:
      - announce "<&c>WARNING! <&f>The conversations <&dq><[is_dup_list].separated_by[<&dq>, <&dq>]><&dq> were duplicated
        in file <&dq><[file].before[?]><&dq>. Not loading these conversations."

    - define conv_list <[conv_list].include[<yaml[<[id]>].list_keys[]>].deduplicate>
    - flag server utility.linear_conversation.loaded_names:|:<yaml[<[id]>].list_keys[].exclude[<[is_dup_list]>]>

    - foreach <yaml[<[id]>].list_keys[].exclude[<[is_dup_list]>]> as:conv:
      - flag server utility.linear_conversation.loaded.<[conv]>:<[id]>

  - flag server utility.linear_conversation.files:!

linear_conversation_msgformat:
  type: format
  debug: false
  format: "[<&a>Linear Conv.<&f>] <text>"
