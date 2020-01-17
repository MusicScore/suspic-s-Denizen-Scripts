# Grid Data Info

1. [Grid Data Task Scripts](#grid-data-task-scripts)
2. [Grid Data Procedure Scripts](#grid-data-procedure-scripts)

## Grid Data Task Scripts

### "grid_data_2d_create"

Creates a virtual 2D grid with the specified width and height.

Optionally, specify a name to initalize the grid with your specified name.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
width | positive integer | Yes | The width of the grid.
length | positive integer | Yes | The length of the grid.
name | string | No | The name of the grid.<br>If not specified, a random name is generated.

#### Determinations

Name | Return Type | Description
:---: | :---: | ---
name | string | The name of the generated grid.

### "grid_data_3d_create"

Creates a virtual 3D grid with the specified width and height.

Optionally, specify a name to initalize the grid with your specified name.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
width | positive integer | Yes | The width of the grid.
length | positive integer | Yes | The length of the grid.
height | positie integer | Yes | The height of the grid.
name | string | No | The name of the grid.<br>If not specified, a random name is generated.

#### Determinations

Name | Return Type | Description
:---: | :---: | ---
name | string | The name of the generated grid.

### "grid_data_delete"

Deletes a grid, if it exists.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### "grid_data_set"

Sets or unsets the value of a point on the grid.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
coord | string | Yes | The coordinate to use, in the format of X,Y for 2D grids or X,Y,Z for 3D grids.
action | string | No | The data action to use. Uses all of the same data actions that the flag, yaml, and define commands use.
value | string | Yes | The value to use. Use "!" or "null" to unset the value instead.

## Grid Data Procedure Scripts

### <proc[grid_dataproc_listallgrids]>

Lists all of the created grids. The grids' data may not already be loaded when this tag is used, but the data will be loaded when any other tag/command is used.

### <proc[grid_dataproc_exists].context[\<name>]>

Returns whether a grid under the specified name exists.

If the grid exists but its data is not loaded, this tag will automatically load that grid's data.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_type].context[\<name>]>

Returns the type of the specified grid. Can only be either 2D or 3D.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_width].context[\<name>]>

Returns the width of the specified grid.

The max X coordinate will be this value minus 1.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_length].context[\<name>]>

Returns the length of the specified grid.

The max Y coordinate will be this value minus 1.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_height].context[\<name>]>

Returns the height of the specified grid, if it is a 3D grid.

The max Z coordinate will be this value minus 1.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_listallvalues].context[\<name>]>

Returns all set values in the grid.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.

### <proc[grid_dataproc_findvalue].context[\<name>|\<value>]>

Returns a list of all coordinates that contains the specified value.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
value | string | Yes | The value to search for.

### <proc[grid_dataproc_get].context[\<name>|\<coord>]>

Returns the value at a specified coordinate in the specified grid.

Will return "null" if no value is set at the coordinate, or "null=INVALID_COORD" if the coordinate is invalid.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
coord | string | Yes | The coordinate to get the value of. Must be in the format "X,Y" for 2D grids, or "X,Y,Z" for 3D grids.

### <proc[grid_dataprocshort_get].context[\<name>|\<coord>]>

Returns the value at the specified coordinate in the specified grid.

Is the same as `<proc[grid_dataproc_get].context[\<name>|\<coord>]>`, except it does no sort of coordinate checking and is therefore marginally faster. As a result, "null=INVALID_COORD" will never be output by this tag.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
coord | string | Yes | The coordinate to get the value of. Must be in the format "X,Y" for 2D grids, or "X,Y,Z" for 3D grids.

### <proc[grid_dataproc_getadacent].context[\<name>|\<coord>]>

Returns a list of all of the adjacent coordinates and their respective values to the specified coordinate.

The list will be in the format `X,Y+1/ABOVE_VAL|X+1,Y/RIGHT_VAL|X,Y-1/BELOW_VAL|X-1,Y/LEFT_VAL` for 2D grids, or `X,Y+1,Z/ABOVE_VAL|X+1,Y,Z/RIGHT_VAL|X,Y-1,Z/BELOW_VAL|X-1,Y,Z/LEFT_VAL|X,Y,Z+1/UPPER_VAL|X,Y,Z-1/LOWER_VAL` for 3D grids.

If an adjacent coordinate is invalid, it will be filled in as "null".

If an adjacent coordinate has an unset value, it will be filled in as "COORDINATE/null".

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
coord | string | Yes | The coordinate to get the value of. Must be in the format "X,Y" for 2D grids, or "X,Y,Z" for 3D grids.

### <proc[grid_dataproc_readcoord].context[\<name>|\<coord>]>

Interprets a given string as a coordinate relative to a grid, and attempts to return a valid form of the coordinate.

If the coordinate is invalid, returns null. Otherwise, returns the coordinates as "X,Y" for 2D grids, or "X,Y,Z" for 3D grids.

#### Parameters

Name | Parameter Type | Required? | Description
:---: | :---: | :---: | ---
name | string | Yes | The name of the grid.
coord | string | Yes | The coordinate to interpret.
