# Factorio Mod: Find Unfiltered Storage Chests

Factorio mod that finds logistic storage chests that are not filtered to a specific item.

**Mod portal:** https://mods.factorio.com/mod/find-unfiltered-storage-chests

You can install the mod using the in-game mod manager, or by downloading it from the mod portal page linked above to your game's `mods` directory.


## Mod description

When placing logistic storage chests, it's very easy to forget to set a filter on them.

Often you'll only notice it much later when you find random items in a storage chest that was supposed to store only one type of item. Or worse, you find random items clogging up the belt of your smelting array, because the storage chest that was supposed to feed the belt with surplus iron ore wasn't actually filtered to iron ore.

This mod finds all unfiltered storage chests and warns you about them by rendering a warning icon on the chest (similar to other warnings, like when an entity has insufficient energy). Additionally, an alert will be fired for every unfiltered storage chest (which can be disabled per player in the mod settings).

When you have a storage chest that actually should be unfiltered (e.g. to store miscellaneous items that don't have a fixed place), you can use a special tool to *acknowledge* the unfiltered storage chest, basically saying "yes, this chest is intentionally unfiltered". The mod will remove the warning and render a little green "acknowledged" icon instead.

## Usage

- Generally you can use storage chests in the same way as before. The mod neither alters the behaviour of storage chests, nor does it add any items (except for a selection tool).
- Unfiltered storage chests will show a warning icon and generate alerts. Setting a filter will remove the warning.
- To acknowledge one or multiple unfiltered storage chests, select the "Acknowledge unfiltered storage chest" tool from the shortcut bar, then left-click to drag a selection area around the chests. They will be marked as "acknowledged" and not generate warnings anymore.
- To undo the acknowledgement, use the tool again but holding Shift and left-clicking, or right-clicking instead.
- A keyboard shortcut to select the tool is available, but without a default key binding.

## Mod compatibility

The mod should be compatible with any mod that adds custom logistic storage containers (as long as they are implemented as `logistic-container` prototypes with `logistic_mode = "storage"`).

The following mods have been tested and are known to be compatible:

- [AAI Containers & Warehouses](https://mods.factorio.com/mod/aai-containers)
- [Merging Chests Logistic](https://mods.factorio.com/mod/WideChestsLogistic)

## Known issues

The core concept of the mod is relatively simple and quite robust.

However, there are some minor issues due to the limitations of the modding API:

- The warning icon uses the same design as the core game's warning icons (insufficient energy, no logistic network, etc.). However, since the warning system can't be customized by mods, the icon is rendered as a simple and static overlay.
- The only type of "custom alerts" that mods can generate are the same alerts that are used by Programmable Speakers. This means that the "unfiltered storage chest" alerts are grouped together with alerts fired by the player's Programmable Speakers.
- Using undo/redo doesn't work with the "acknowledged" flag. However, blueprinting acknowledged unfiltered chests works fine.

## Credits

Special thanks to my wonderful girlfriend [Aurora_Bee](https://deadinsi.de/@Aurora_Bee) for the graphics and emotional support. 💜

## Support

Feel free to report bugs and mod incompatibilities, or to request new features either on the [Discussion page](https://mods.factorio.com/mod/find-unfiltered-storage-chests/discussion) or in the [GitHub issues](https://github.com/binaryDiv/factorio-find-unfiltered-storage-chests).
