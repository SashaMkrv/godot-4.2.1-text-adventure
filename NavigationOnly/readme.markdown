# (Almost) No State Prototype
What it says on the tin. This prototype comes with text-adventures that are essentially stateless, beyond keeping track of which room the player is in.

Tiny engine for making tiny text adventures and playing them. You can save the maps you make, but you can't save the state of the maps you play (oopsie-daisies).

## The Map Browser

The map browser looks in the `user://maps` directory (or makes a `user://maps` directory if none is found) for files with the `.mn8a` extension and lists the found files. Selecting a file will open it's name and description in a map info module at the bottom of the screen. From there you can open the map (or "export" it).

You can make new maps from this screen, as well as "import" maps by copy-pasting in some JSON, or "export" maps with some copy-pasting of JSON. These are here to shunt maps in and out of your browser's local DBs on web builds.

Godot's `user://` directory changes between operating systems. At time of writing (November 1st, 2024) and Godot version 4.3, these directories should be as follows for Windows, Mac, and GNU/Linux:

- Windows: `%APPDATA%\Godot\app_userdata\[project_name]`
- macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]`
- Linux: `~/.local/share/godot/app_userdata/[project_name]`

(Taken from the [File Paths in Godot](https://docs.godotengine.org/en/4.3/tutorials/io/data_paths.html) doc page.)

### The .mn8a file extension
I thought it was cute. "Mini Text Adventure", to Minita, to mn8a. Mostly it just means ignoring other possible files in the same folder, isntead of trying to parse unrelated JSON or text files. It's like a prospective .project file extension.

Practically it just means any map JSON file you copy into the app's maps folder should end with a `.mn8a` file extension, and files created by the app will have the `.mn8a` extension.

## The Editor

From the editor you can edit your maps and play them (yeah, you have to go through the editor to play the maps.)

*NOTE*: You have to manually save things. Playing the map does not save to disk. Opening or "importing" a new map from the map browser will not save it to disk. Nothing but hitting `cmd/ctrl+S` or hitting the `save map` button will save the map to disk.

### The Map Tab

When you first open a map in the editor, you will be in the Map tab. This has the map name and desription fields. These only show in the map browser.

### The Item Tab

The item tab is where you edit all the items in your map, as well identify which room will the player starts in.

#### What? Is this is grid?
Uh. Yes. That's where you browse and create your map items. Sorry. Or not sorry? This was not the focus of the prototype, but I will admit it was maybe not the best choice. We can pretend it is a marvelous, very functional map, showing all of your game and the connections between all items. It is not this. It is a 2x2 grid of coloured, textless buttons. If you click one, if there's an item in that grid space, it'll open it in the item editor. If there isn't an item there, it'll make a new one, and open it in the item editor. So you can edit it. If you mouse over a defined item in the grid, it will show you its identifier string in a tooltip.

If you change the cell color of an item, the corresponding button in the grid will change to this color as well.

(And now, I will tell you something awful. Even void of almost any useful information beyond a color (oh, right, you can change the color of the item in the grid!) and a string you can only occassionaly see, I've found I like this better than a list.)

## The Model
Everything is an item.
The rooms are items. The items are items. If you have an apple, you an examine it, and you can enter it. You just can't pick it up. Because that's state.

Each item has an identifier (hopefully unique), used in scripts (such as for room connections or for scenery), a display name, a description, and a set of `scripts` for describing connections, scenery, and aliasing player commands (e.g. `TALK JULIE` can become `GO JULIE`, and in connections, the direction `JULIE` leads to a `talk_julie_1` item. Now you have a very, very rudimentary dialogue system.)

### The Syntax
There is very little in the way of syntax. Any 'scripts' you might write are just lists of keys and values, separated by `:`s, each pair separated by newlines.

#### Connections

Connections are defined with a direction as a key, and a destination item's identifier as a value. E.g. :
```
NORTH: north_hallway_1
SOUTH: south_hallway_1
WEST: entry_way
```
Now `GO NORTH` will change the current room to `north_hallway_1`, and as a bonus, so will the command `N`, from the built in short-hand commands.

#### Scenery

Scenery is defined as a player-usable string, and an item's indentifier as a value, the description of which will be displayed to the player. E.g.:
```
FOREST: forest_scenery_1
CARRIAGE: carriage_scenery_1
```

Now `EXAMINE FOREST` or `X FOREST` commands will show the description of the `forest_scenery_1` item. This only appends output to the console window, and does not clear the screen or change the current room the way GO commands and connections do.

#### Aliases

Aliases are a way to transform player commands into GO or EXAMINE commands, for the ham-fisted illusion of genuine verb-y interactions. This uses an original player input string as a key, followed by a transformed command as a value. There's no wildcarding or regex or partial command transformation here. It's very all or nothing. E.g.:
```
TALK JULIE: GO JULIE
TALK STEVE: EXAMINE STEVE
```

Now the `TALK JULIE` command will turn into `GO JULIE` and try to use follow the `JULIE` direction which is hopefully defined in this item's connections script. Maybe Steve is more terse and does justify a full dialogue tree or room change, and we can get away with just displaying some text, so we can use an EXAMINE command instead.
