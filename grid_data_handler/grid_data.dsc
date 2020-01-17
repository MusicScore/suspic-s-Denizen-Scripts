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

    - inject grid_dataproc_exists.creator_check instantly

    - flag server grid_data/<def[name]>/x:<def[width]>
    - flag server grid_data/<def[name]>/y:<def[length]>
    - flag server grid_data/<def[name]>/type:2D
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

    - inject grid_dataproc_exists.creator_check instantly

    - flag server grid_data/<def[name]>/x:<def[width]>
    - flag server grid_data/<def[name]>/y:<def[length]>
    - flag server grid_data/<def[name]>/z:<def[height]>
    - flag server grid_data/<def[name]>/type:3D
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
    - foreach <server.list_flags.filter[starts_with[grid_data/<def[name]>/]]>:
        - flag server <def[value]>:!



###########################################################
# Sets the data value at a coordinate in a grid.
# Use "null" or "!" to unset the data value.
#
# Definitions/Parameters:
#     name  : The name of the grid to edit.
#     coord : The coordinates as a comma-separated list of integers. For
#             example, "3,2" for a 2D grid, or "1,10,3" for a 3D grid.
#     data  : The data to put at the specified coordinate.
#
#


grid_data_set:
    type: task
    debug: false
    speed: 0
    definitions: name|coord|data
    script:
    - if !<proc[grid_dataproc_exists].context[<def[name]||+>]>:
        - debug ERROR "A grid by the name <&dq><def[name]||null><&dq> does not exist!"
        - stop

    - define readcoord <proc[grid_dataproc_readcoord].context[<def[name]>|<def[coord]>]>

    - if <def[readcoord]> == null:
        - debug ERROR "Could not fetch a <server.flag[grid_data/<def[name]>/type]> coordinate from <def[coord]>!"
        - stop

    - define is_3d <server.flag[grid_data/<def[name]>/type].is[EQUALS].to[3D]>

    - define max_x <server.flag[grid_data/<def[name]>/x]>
    - define max_y <server.flag[grid_data/<def[name]>/y]>
    - define max_z <server.flag[grid_data/<def[name]>/z]||<def[coord].get[3].add[1]||1>>

    - if <def[readcoord].get[1]> >= <def[max_x]> || <def[readcoord].get[2]> >= <def[max_y]> || ( <def[is_3d]> == "3D" && <def[readcoord].get[3]||0> >= <def[max_z]> ):
        - debug ERROR "Attempting to set data for a coordinate beyond the max coordinate point <def[max_x].sub[1]>,<def[max_y].sub[1]><tern[<def[is_3d]>].pass[,<def[max_z]>].fail[]>"

    - define data <def[raw_context].after[|].after[|].replace[|].with[&pipe]>
    - define flag_list <server.flag[grid_data/<def[name]>/list_data]||li@>
    - define coord <def[readcoord].separated_by[,]>

    - if !<def[flag_list].filter[starts_with[<def[coord]>]].is_empty>:
        - define flag_list <def[flag_list].exclude[<def[flag_list].filter[starts_with[<def[coord]>]]>]>

    - if !<list[!|null].contains[<def[data]>]>:
        - define flag_list:->:<def[coord]>/<def[data]>
        - flag server grid_data/<def[name]>/list_data:!|:<def[flag_list]>



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
    - if !<def[1].matches[[a-zA-Z0-9_\-]+]||false>:
        - determine false
    - determine <server.list_flags.filter[starts_with[grid_data/]].parse[after[/].before[/]].deduplicate.contains[<def[1]>]>

    # Helper script section for procedure scripts
    proc_check:
    - if !<proc[grid_dataproc_exists].context[<def[1]||+>]>:
        - determine null

    # Helper script section for "grid_data_2d_create" and "grid_data_3d_create"
    creator_check:
    - if <server.list_flags.filter[starts_with[grid_data/]].parse[after[/].before[/]].contains[<def[name]>]>:
        - debug ERROR "A <server.flag[grid_data/<def[name]>/type]> grid by the name <def[name]> already exists! Not creating."
        - stop

    - if !<def[name].matches[[a-zA-Z0-9_\-]+]>:
        - debug ERROR "A grid name must be alphanumeric, including underscores and dashes!"
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
    - determine <server.flag[grid_data/<def[1]>/type]>



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
    - determine <server.flag[grid_data/<def[1]>/x]>



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
    - determine <server.flag[grid_data/<def[1]>/y]>



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
    - if <server.flag[grid_data/<def[1]>/type]> != 3D:
        - determine null
    - determine <server.flag[grid_data/<def[1]>/z]>



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
    - determine <server.flag[grid_data/<def[1]>/list_data].map_get[<proc[grid_dataproc_readcoord].context[<def[1]>|<def[2]>].separated_by[,]>].replace[&pipe].with[|]||null>



##############################################
# Returns the value set at the specific coordinate on the grid, or null if the
# value isn't set OR if the data cannot be grabbed. Intended as a shortcut to
# the much heavier alternative "grid_dataproc_get".
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
    - determine <server.flag[grid_data/<def[1]>/list_data].map_get[<proc[grid_dataproc_readcoord].context[<def[1]>|<def[2]>].separated_by[,]>].replace[&pipe].with[|]||null>



##############################################
# Returns a list of all of the grids that the server recognizes.
#
#

grid_dataproc_listallgrids:
    type: procedure
    debug: false
    script:
    - determine <server.list_flags.filter[starts_with[grid_data/]].parse[after[/].before[/]].deduplicate||li@>



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
    - determine <server.flag[grid_data/<def[1]>/list_data].alphanumeric||li@>



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
    - if <server.flag[grid_data/<def[1]>/type]> == "3D":
        - if <def[coord].size> < 3:
            - determine null
        - determine <def[coord].get[1].to[3]>
    - else:
        - if <def[coord].size> < 2:
            - determine null
        - determine <def[coord].get[1].to[2]>
