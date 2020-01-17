################################################################################
# Task scripts
################################################################################


###########################################################
# NOTE ABOUT THE TASK SCRIPTS:
#
#    If a task script has a determination, you can get the value of the
#    determination by running the script with a waited run command, using the
#    save argument, then using this tag:
#    <entry[SAVENAME].created_queue.determination.map_get[KEY]>
#
#    For example, if you want to get the result of a created 4x5 grid from the
#    script "grid_data_2d_create", you would use:
#
#    - ~run grid_data_2d_create def:4|5 save:new_grid
#    - narrate <entry[new_grid].created_queue.determination.map_get[name]>
#
#


###########################################################
# Initializes a 2D grid.
#
# Definitions/Parameters:
#     width  : The width of the grid.
#     length : The length of the grid.
#     name   : (Optional) The name to give this grid data.
#
# Determination Keys:
#     name: Returns the name of the grid that was generated.
#
#

grid_data_2d_create:
    type: task
    debug: false
    speed: 0
    definitions: width|length|name
    script:
    - if !<def[width].is_integer||false> || <def[width].as_decimal||0> <= 0 || !<def[length].is_integer||false> || <def[length].as_decimal||0> <= 0:
        - debug ERROR "A positive integer width and length is required!"
        - stop

    - define name <def[name]||grid2d-<util.random.uuid>>

    - inject grid_dataproc_exists.creator_check

    - flag server grid_data/created:->:<def[name]>
    - yaml id:grid-data-<def[name]> create
    - yaml id:grid-data-<def[name]> set x:<def[width]>
    - yaml id:grid-data-<def[name]> set y:<def[length]>
    - yaml id:grid-data-<def[name]> set type:2D
    - yaml id:grid-data-<def[name]> savefile:./grid_data/<def[name]>.yml
    - determine name/<def[name]>



###########################################################
# Initializes a 3D grid.
#
# Definitions/Parameters:
#     width  : The width of the grid.
#     length : The length of the grid.
#     height : The height of the grid.
#     name   : (Optional) The name to give this grid data.
#
# Determination Keys:
#     name: Returns the name of the grid that was generated.
#
#

grid_data_3d_create:
    type: task
    debug: false
    speed: 0
    definitions: width|length|height|name
    script:
    - if !<def[width].is_integer||false> || <def[width].as_decimal||0> <= 0 || !<def[length].is_integer||false> || <def[length].as_decimal||0> <= 0 || !<def[height].is_integer||false> || <def[height].as_decimal||0> <= 0:
        - debug ERROR "A positive integer width, length, and height is required!"
        - stop

    - define name <def[name]||grid3d-<util.random.uuid>>

    - inject grid_dataproc_exists.creator_check

    - flag server grid_data/created:->:<def[name]>
    - yaml id:grid-data-<def[name]> create
    - yaml id:grid-data-<def[name]> set x:<def[width]>
    - yaml id:grid-data-<def[name]> set y:<def[length]>
    - yaml id:grid-data-<def[name]> set z:<def[height]>
    - yaml id:grid-data-<def[name]> set type:3D
    - yaml id:grid-data-<def[name]> savefile:./grid_data/<def[name]>.yml
    - determine name/<def[name]>



###########################################################
# Deletes a grid.
#
# Definitions/Parameters:
#     name   : The name of the grid to delete.
#
#

grid_data_delete:
    type: task
    debug: false
    speed: 0
    definitions: name
    script:
    - if !<proc[grid_dataproc_exists].context[<def[name]||+>]>:
        - debug DEBUG "A grid <&dq><def[name]||null><&dq> does not exist! Was it already deleted?"
        - stop
    - flag server grid_data/created:!|:<server.flag[grid_data/created].exclude[<def[name]>]>
    - yaml id:grid-data-<def[name]> unload



###########################################################
# Sets the data value at a coordinate in a grid.
# Use "null" or "!" to unset the data value.
#
# Definitions/Parameters:
#     name   : The name of the grid to edit.
#     coord  : The coordinates as a comma-separated list of integers. For
#              example, "3,2" for a 2D grid, or "1,10,3" for a 3D grid.
#     action : (Optional) The data action to use. Can be any valid Denizen data
#              action.
#     data   : The data to put at the specified coordinate.
#
#


grid_data_set:
    type: task
    debug: false
    speed: 0
    definitions: name|coord
    script:
    - if !<proc[grid_dataproc_exists].context[<def[name]||+>]>:
        - debug ERROR "A grid by the name <&dq><def[name]||null><&dq> does not exist!"
        - stop

    - define coord <proc[grid_dataproc_readcoord].context[<def[name]>|<def[coord]>]>

    - if <def[coord]> == null:
        - debug ERROR "Could not fetch a <server.flag[grid_data/<def[name]>/type]> coordinate from <def[coord]>!"
        - stop

    - define readcoord <def[coord].split[,]>
    - define is_3d <yaml[grid-data-<def[name]>].read[type].is[EQUALS].to[3D]>

    - define max_x <yaml[grid-data-<def[name]>].read[x]>
    - define max_y <yaml[grid-data-<def[name]>].read[y]>
    - define max_z <yaml[grid-data-<def[name]>].read[z]||<def[coord].get[3].add[1]||1>>

    - if <def[readcoord].get[1]> >= <def[max_x]> || <def[readcoord].get[2]> >= <def[max_y]> || ( <def[is_3d]> && <def[readcoord].get[3]||0> >= <def[max_z]> ):
        - debug ERROR "Attempting to set data for a coordinate beyond the max coordinate point <def[max_x].sub[1]>,<def[max_y].sub[1]><tern[<def[is_3d]>].pass[,<def[max_z]>].fail[]>"

    - define data <def[raw_context].after[|].after[|]>
    - if <def[data]> == null:
        - yaml id:grid-data-<def[name]> set coords.<def[coord]>:!

    - else:
        - if <def[data].starts_with[!||]>:
            - define data <def[data].after[|].after[|]>

        - else if <def[data].starts_with[||]>:
            - define data <def[data].after[|].after[|]>

        - else if <list[+|-|*|/|-<&gt>|<&lt>-].contains[<def[data].before[|]>]>:
            - define action <def[data].before[|]>
            - define data <def[data].after[|]>

        - if <def[action]||null> != null:
            - yaml id:grid-data-<def[name]> set coords.<def[coord]>:<def[action]>:<def[data]>
        - else:
            - yaml id:grid-data-<def[name]> set coords.<def[coord]>:<def[data]>



################################################################################
# World scripts
################################################################################

grid_dataevt:
    type: world
    debug: false
    events:
        # Backup the grid data
        on system time hourly:
        - inject locally "events.on server shutdown"

        # Save the grid data
        on server shutdown:
        - foreach <yaml.list.filter[starts_with[grid-data-]]>:
            - yaml id:<def[value]> savefile:./grid_data/<def[value].after[grid-data-]>.yml




################################################################################
# Procedure scripts
################################################################################

##############################################
# Returns whether a grid by the specified name exists.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_exists:
    type: procedure
    debug: false
    script:
    - if !<def[1].matches[[a-zA-Z0-9_\-]+]||false> || !<server.flag[grid_data/created].contains[<def[1]>]||false>:
        - determine false

    - if !<yaml.list.contains[grid-data-<def[1]>]> && <server.has_file[./grid_data/<def[1]>.yml]>:
        - yaml id:grid-data-<def[1]> create
        - yaml id:grid-data-<def[1]> load:./grid_data/<def[1]>.yml
        - determine true
    - determine <yaml.list.contains[grid-data-<def[1]>]>

    # Helper script section for procedure scripts
    proc_check:
    - if !<proc[grid_dataproc_exists].context[<def[1]||+>]>:
        - determine null

    # Helper script section for "grid_data_2d_create" and "grid_data_3d_create"
    creator_check:
    - if !<def[name].matches[[a-zA-Z0-9_\-]+]>:
        - debug ERROR "A grid name must be alphanumeric, including underscores and dashes!"
        - stop

    - if <proc[grid_dataproc_exists].context[<def[name]>]>:
        - debug ERROR "A <yaml[grid-data-<def[name]>].read[type]> grid by the name <def[name]> already exists! Not creating."
        - stop



##############################################
# Returns the type of the grid, or null if the grid doesn't exist.
# Can only return either 2D or 3D.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_type:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - determine <yaml[grid-data-<def[1]>].read[type]>



##############################################
# Returns the width of the grid. The max X coordinate will be this value minus
# 1.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_width:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - determine <yaml[grid-data-<def[1]>].read[x]>



##############################################
# Returns the length of the grid. The max Y coordinate will be this value minus
# 1.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_length:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - determine <yaml[grid-data-<def[1]>].read[y]>



##############################################
# Returns the height of the grid, if it is a 3D grid. The max Z coordinate will
# be this value minus 1.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_height:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - if <yaml[grid-data-<def[1]>].read[type]> != 3D:
        - determine null
        - determine <yaml[grid-data-<def[1]>].read[z]>



##############################################
# Returns the value set at the specific coordinate on the grid, or:
#     - null if the value isn't set
#     - null=INVALID_COORD if the coordinate specified is invalid
#
# Contexts:
#     name  : The name of the grid.
#     coord : The coordinates as a comma-separated list of integers. For
#             example, "3,2" for a 2D grid, or "1,10,3" for a 3D grid.
#
#

grid_dataproc_get:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - define coord <proc[grid_dataproc_readcoord].context[<def[1]>|<def[2]>]>
    - if <def[coord]> == null:
        - determine "null=INVALID_COORD"
    - determine <yaml[grid-data-<def[1]>].read[coords.<def[coord]>]>



##############################################
# Returns the value set at the specific coordinate on the grid, or null if the
# value isn't set OR if the data cannot be grabbed. Intended as a shortcut to
# the slightly heavier (but safer) alternative "grid_dataproc_get".
#
# Contexts:
#     name  : The name of the grid.
#     coord : The coordinates as a comma-separated list of integers. For
#             example, "3,2" for a 2D grid, or "1,10,3" for a 3D grid.
#
#

grid_dataprocshort_get:
    type: procedure
    debug: false
    script:
    - determine <yaml[grid-data-<def[1]>].read[coords.<def[2]>]>



##############################################
# Returns a list of all of the grids that the server recognizes.
#
#

grid_dataproc_listallgrids:
    type: procedure
    debug: false
    script:
    - determine <server.list_files[./grid_data].parse[before[.yml]].include[<yaml.list.filter[starts_with[grid-data-]].parse[after[grid-data-]]>].deduplicate>



###########################################################
# Returns a map of all of the set values in the specified grid.
# The map will be in the format "X,Y/value|..." or "X,Y,Z/value|...".
#
# For convenience, if a value has a pipe in it, the pipe will automatically be
# escaped to "&pipe".
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_listallvalues:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - define output <list[]>
    - foreach <yaml[grid-data-<def[1]>].list_keys[coords].alphanumeric||li@>:
        - define output:->:<def[value]>/<yaml[grid-data-<def[1]>].read[coords.<def[value]>].replace_text[|].with[&pipe]>
    - determine <def[output]>



###########################################################
# Returns an unordered list of all coordinates that contains the specified
# value.
#
# Contexts:
#     name  : The name of the grid.
#     value : The value to find.
#
#

grid_dataproc_findvalue:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - define find <def[raw_context].after[|]>
    - define output <list[]>
    - foreach <yaml[grid-data-<def[1]>].list_keys[coords]>:
        - if <yaml[grid-data-<def[1]>].read[coords.<def[value]>]> == <def[find]>:
            - define output:->:<def[value]>
    - determine <def[output]>



###########################################################
# Returns a list of all adjacent tiles to a coordinate (X,Y), in this order:
#     X,Y+1/ABOVE_VAL|X+1,Y/RIGHT_VAL|X,Y-1/BELOW_VAL|X-1,Y/LEFT_VAL
#
# Or, if the grid is 3D,
#     X,Y+1,Z/ABOVE_VAL|X+1,Y,Z/RIGHT_VAL|X,Y-1,Z/BELOW_VAL|X-1,Y,Z/LEFT_VAL|X,Y,Z+1/UPPER_VAL|X,Y,Z-1/LOWER_VAL
#
# If any of the adjacent coordinates are invalid, then it will be filled in as
# "null" instead of "X,Y,Z/VALUE".
#
# If any of the adjacent coordinates have no value, then it will be filled in
# as "X,Y,Z/null".
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_getadjacent:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check

    - define base_coord <proc[grid_dataproc_readcoord].context[<def[1]>,<def[2]>].split[,]>
    - define check_coords <list[<def[base_coord].set[<def[base_coord].get[2].add[1]>].at[2].separated_by[,]>|<def[base_coord].set[<def[base_coord].get[1].add[1]>].at[1].separated_by[,]>|<def[base_coord].set[<def[base_coord].get[2].sub[1]>].at[2].separated_by[,]>|<def[base_coord].set[<def[base_coord].get[1].sub[1]>].at[1]>].separated_by[,]>
    - if <yaml[grid-data-<def[1]>].read[type]> == "3D":
        - define check_coords:|:<def[base_coord].set[<def[base_coord].get[3].add[1]>].at[3].separated_by[,]>|<def[base_coord].set[<def[base_coord].get[3].sub[1]>].at[3].separated_by[,]>

    - define output <list[]>
    - foreach <def[check_coords]>:
        - define new_coord <proc[grid_dataproc_readcoord].context[<def[1]>,<def[value]>]>
        - if <def[new_coord]> == null:
            - define output:->:null
            - foreach next
        - define output:->:<def[new_coord]>/<yaml[grid-data-<def[1]>].read[coords.<def[value]>]||null>

    - determine <def[output]>



###########################################################
# Returns a string as a valid set of coordinates relative to a grid.
#
# Contexts:
#     name : The name of the grid.
#
#

grid_dataproc_readcoord:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check

    - define coord <def[2].split[,].filter[is_integer].filter[is[OR_MORE].than[0]]>
    - if <yaml[grid-data-<def[1]>].read[type]> == "3D":
        - if <def[coord].size> < 3 || <def[coord].get[1]> >= <yaml[grid-data-<def[1]>].read[x]> || <def[coord].get[2]> >= <yaml[grid-data-<def[1]>].read[y]> || <def[coord].get[3]> >= <yaml[grid-data-<def[1]>].read[z]>:
            - determine null
        - determine <def[coord].get[1].to[3].separated_by[,]>
    - else:
        - if <def[coord].size> < 2 || <def[coord].get[1]> >= <yaml[grid-data-<def[1]>].read[x]> || <def[coord].get[2]> >= <yaml[grid-data-<def[1]>].read[y]>:
            - determine null
        - determine <def[coord].get[1].to[2].separated_by[,]>
