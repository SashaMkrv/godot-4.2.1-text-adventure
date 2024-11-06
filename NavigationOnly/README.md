# (Almost) No State Prototype

What it says on the tin. This prototype comes with text-adventures that are
essentially stateless, beyond keeping track of which room the player is in.

It's a tiny engine for making tiny text adventures and playing them. You can 
save and browse and share the
maps you make, but you can't save the state of the maps you play.

## The Map Browser

The map browser looks in the `user://maps` directory (or makes a
`user://maps` directory if none is found) for files with the
`.mn8a` extension and lists the found files. Selecting a file will open its name
and description in a map info module at the bottom of the screen. From there you
can open the map (or "export" it).

You can make new maps from this screen, as well as "import" maps by copy-pasting
in some JSON, or "export" maps with some copy-pasting of JSON. These are here to
shunt maps in and out of your browser's local DBs on web builds.

Godot's
`user://` directory changes between operating systems. At time of writing (
November 1st, 2024) and Godot version 4.3, these directories should be as
follows for Windows, Mac, and GNU/Linux:

- Windows: `%APPDATA%\Godot\app_userdata\[project_name]`
- macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]`
- Linux: `~/.local/share/godot/app_userdata/[project_name]`

(Taken from
the [File Paths in Godot](https://docs.godotengine.org/en/4.3/tutorials/io/data_paths.html)
doc page.)

### The .mn8a file extension

I thought it was cute. "Mini Text Adventure", to Mini TA, to Minita, to mn8a.
Mostly it just means ignoring other possible files in the same folder, instead
of trying to parse unrelated JSON or text files. It's like a prospective
.project file extension.

Practically it just means any map JSON file you copy into the app's maps folder
should end with a
`.mn8a` file extension, and files created by the app will have the
`.mn8a` extension.

## The Editor

From the editor you can edit your maps and play them (yeah, you have to go
through the editor to play the maps.)

*NOTE*: You have to manually save things. Playing the map does not save to disk.
Opening or "importing" a new map from the map browser will not save it to disk.
Nothing but hitting
`cmd/ctrl+S` or hitting the `save map` button will save the map to disk.

### The Map Tab

When you first open a map in the editor, you will be in the Map tab. This has
the map name and description fields. These only show in the map browser.

### The Item Tab

The item tab is where you edit all the items in your map, as well identify which
room will the player starts in.

#### Wait. What? Why is there a grid here?

That's where you browse and create your map items.

(I'm sorry. Or
not sorry? This was not the focus of the prototype, but I will admit it was
maybe not the best choice. We can pretend it is a marvelous, very functional
map, showing all of your game and the connections between all items.

It is not this.)

It is a 2x2 grid of coloured, text-less buttons. When you click one, if
there is already
an item in that grid space, it'll open it in the item editor. If there isn't an
item there, it'll make a new one, and open it in the item editor. So you can
edit it. If you mouse over a defined item in the grid, it will show you its
identifier string in a tooltip.

If you change the cell color of an item, the corresponding button in the grid
will change to this color as well. If you change the identifier string of an 
item, it will show the string when you hover over the corresponding button 
as a tooltip.

## The Map Model

Everything in a map is an item.
The rooms are items. The items are items. If you have an apple, you can examine
it like scenery, and you can enter it like a room. They're all the same. You
just can't easily pick the apple up, add it to an inventory, and move it around 
arbitrarily, because 
that's 
state, of which we have only a single string: the identifier of the current 
room.

### Item Definitions

Each item has the following:
- an identifier (hopefully unique), used in scripts 
(such as for
room connections or for scenery)
- a display name (shown at the top of the 
play screen when the item is the current room)
- a description (displayed 
when changing rooms, or when examining an item as scenery)
- and a set of `scripts` for describing connections (e.g. `NORTH: 
north_hallway`), scenery 
(e.g. `TREES: trees_scenery`), and 
aliasing player 
commands (e.g. `GO NORTH` can become `EXAMINE BLOCKED_PATH`, and if you have 
  `BLOCKED_PATH: block_path_description` or similar defined in the scenery 
  script, you can provide the player 
  with info about a blocked path via the description on the 
  `block_path_description` item. )

### Syntax and Scripts

Items are identified using unique (hopefully. Behaviour for maps with 
conflicting identifiers is undefined.) strings, which are case-sensitive. 
`entry_way_1` is not equivalent to `Entry_Way_1`. These identifier strings 
preferably contain no whitespace; prefer `entry_way_1`, `EntryWay1` or 
`entry-way-1`, or any of your preferred variable name styling conventions 
(`entry_Way-1`, anyone?), 
over 
`entry way 1`.

There is very little in the way of actual syntax in the scripts. Any 'scripts' 
you might write are
just flat lists key-value pairs joined by a
`:`. New key-value pair in your script? New line.

However, player commands are _not_ case-insensitive. `North`, `north`, and 
`NORTH` are all equivalent. `EXAMINE APPLE` and `Examine Apple` are 
similarly identical on the player-side.

#### Connections

Connections are defined with a direction as a key, and a 
destination 
item's
identifier as a value. E.g. :

```
NORTH: north_hallway_1
SOUTH: south_hallway_1
WEST: entry_way
```

Now `GO NORTH` will change the current room to
`north_hallway_1`, and as a bonus, so will the command
`N`, from the built-in shorthand commands.

Keys in scenery are accessible via commands, and so are case-insensitive.

#### Scenery

Scenery is specified with a string the player can use to identify the object 
in commands (e.g. "apple") as a key, and an item's identifier as a value (e.
g. "apple_scenery"), 
the 
description of 
which 
will be displayed to the player. E.g.:

```
FOREST: forest_scenery_1
CARRIAGE: carriage_scenery_1
```

Now `EXAMINE FOREST` or `X FOREST` commands will show the description of the
`forest_scenery_1` item. This only appends output to the console window, and
does not clear the screen or change the current room the way GO commands and
connections do.

Keys in scenery are accessible via commands, and so are case-insensitive.

#### Aliases

Aliases are a way to transform player commands into GO or EXAMINE commands, for
an unwieldy illusion of genuine verb-y interactions. This uses an original
player input string as a key, followed by a transformed command as a value.
There's no wildcards or regex or partial matching here. It's very all or
nothing. E.g.:

```
TALK JULIE: GO JULIE
TALK STEVE: EXAMINE STEVE
```

Now the `TALK JULIE` command will turn into `GO JULIE` and try to use follow the
`JULIE` direction which is hopefully defined in this item's connections script.
Maybe Steve is more terse and does justify a full dialogue tree or room change,
and we can get away with just displaying some text, so we can use an EXAMINE
command instead.

Both the keys and values of aliases are commands, and so are case-insensitive.

## Map Serialization

Map files are saved in JSON format, and may actually be far easier to edit 
directly than using the editor (that's why we prototype...)

A minimum example file looks like this:

```JSON
{
  "mapDescription": "Map description.",
  "mapName": "Map name.",
  "placedItems": {
    "0,0": {
      "aliasScript": "",
      "color": "000000",
      "connectionsScript": "",
      "description": "",
      "displayName": "",
      "sceneryScript": "",
      "uniqueName": "starter"
    }
  },
  "startingRoom": "starter"
}
```

The `mapDescription` and `mapName` fields are only used in the map browser. 

The `placedItems` dictionary is a collection of all the items in a map, 
keyed by their 
position in the editor's grid. The placed item keys are integer coordinates 
joined by a comma. Items with 
badly formatted 
keys should just be moved to an inaccessible place on the grid (100, 100) by 
when the file is read. 
Items not visible on the grid should still be usable during play, you just 
won't be able to edit them via the built-in editor.

On items, `color` is a hex-code _without_ a prefixed `#`.

Each of the item fields otherwise is as described in [Item Definitions]
(#item-definitions).