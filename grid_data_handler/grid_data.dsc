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
        - stop
    - foreach <server.list_flags.filter[starts_with[grid_data/<def[name]>/]]>:
        - flag server <def[value]>:!



###########################################################
# Sets the data value at a coordinate in a grid.
#
# Definitions/Parameters:
#     grid_name : The name of the grid to edit.
#     coord     : The coordinates as a comma-separated list of integers. For
#                 example, "3,2" for a 2D grid, or "1,10,3" for a 3D grid.
#     data      : The data to put at the specified coordinate.
#
#


grid_data_set:
    type: task
    debug: false
    speed: 0
    definitions: grid_name|coord|data
    script:
    - if !<proc[grid_dataproc_exists].context[<def[grid_name]||+>]>:
        - debug ERROR "A grid by the name <&dq><def[grid_name]||null><&dq> does not exist!"
        - stop

    - define coord <def[coord].split[,].parse[as_decimal].exclude[null]>

    - if <def[coord].size> < 2:
        - debug ERROR "Provided coordinate <&dq><def[coord].separated_by[,]><&dq> has <def[coord].size> components, but at least 2 components are required!"
        - stop

    - define type <proc[grid_dataproc_type].context[<def[grid_name]>]>

    - if <def[type]> == "3D":
        - if <def[coord].size> < 3:
            - debug ERROR "Using a 3D grid <&dq><def[grid_name]><&dq>, but only supplied a 2D coordinate <&dq><def[coord].separated_by[,]><&dq>!"
            - stop

    - define data <def[raw_context].after[|].after[|]>
    - define flag_list <server.flag[grid_data/<def[grid_name]>/list_data]||li@>
    - define final_pos <proc[grid_dataproc_posfromcoord].context[<def[grid_name]>|<def[coord].after[li@]>]>


    - if <list[!|null].contains[<def[data]>]>:
        - if <def[flag_list].size> < <def[final_pos]>:
            - stop
        - define flag_list <def[flag_list].set[null].at[<def[final_pos]>]>
        - while <def[flag_list].last||null> == null:
            - define flag_list <def[flag_list].remove[last]>
        - flag server grid_data/<def[grid_name]>/list_data:!|:<def[flag_list]>

    - else:
        - if <def[flag_list].size> < <def[final_pos]>:
            - define flag_list <def[flag_list].pad_right[<def[final_pos]>].with[null]>

        - flag server grid_data/<def[grid_name]>/list_data:!|:<def[flag_list].set[<def[data]>].at[<def[final_pos]>]>



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
#     - null=INVALID_COORD_FORMAT if the format of the coordinate is faulty
#
# Contexts:
#     name : The name of the grid.
#     x    : The X component of the coordinate.
#     y    : The Y component of the coordinate.
#     z    : The Z component of the coordinate.
#
#

grid_dataproc_get:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - if !<def[2].is_integer||false> || <def[2].as_decimal> < 0 || !<def[3].is_integer||false> || <def[3].as_decimal> < 0 || ( <server.flag[grid_data/<def[1]>/type]> == 3D && ( !<def[4].is_integer||false> || <def[4].as_decimal> < 0 ) ):
        - determine "null=INVALID_COORD_FORMAT"

    - if <def[2]> >= <server.flag[grid_data/<def[1]>/x]> || <def[3]> >= <server.flag[grid_data/<def[1]>/y]> || ( <server.flag[grid_data/<def[1]>/type]> == 3D && <def[4]> >= <server.flag[grid_data/<def[1]>/z]> ):
        - determine "null=INVALID_COORD"

    - determine <proc[grid_dataprocshort_get].context[<def[raw_context]>]>



##############################################
# Returns the value set at the specific coordinate on the grid, or null if the
# value isn't set OR if the data cannot be grabbed. Intended as a shortcut to
# the much heavier alternative "grid_dataproc_get".
#
# Contexts:
#     name : The name of the grid.
#     x    : The X component of the coordinate.
#     y    : The Y component of the coordinate.
#     z    : The Z component of the coordinate.
#
#

grid_dataprocshort_get:
    type: procedure
    debug: false
    script:
    - define y_off <server.flag[grid_data/<def[1]>/x]>
    - if <server.flag[grid_data/<def[1]>/type]> == 3D:
        - define z_off <server.flag[grid_data/<def[1]>/y].mul[<def[y_off]>]>

    - determine <server.flag[grid_data/<def[1]>/list_data].get[<proc[grid_dataproc_posfromcoord].context[<def[raw_context]>]>]||null>



###########################################################
# Private helper procedure to calculate the final list position of a coordinate
# with respect to a specific grid.
#
#

grid_dataproc_posfromcoord:
    type: procedure
    debug: false
    script:
    - inject grid_dataproc_exists.proc_check
    - define y_off <server.flag[grid_data/<def[1]>/x]>
    - if <server.flag[grid_data/<def[1]>/type]> == "3D":
        - define z_off <server.flag[grid_data/<def[1]>/y].mul[<def[y_off]>]>

    - determine <def[2].add[<def[3].mul[<def[y_off]>]>].add[<def[4].mul[<def[z_off]||0>]||0>].add[1]||-1>
