# Glowshrooms

Bioluminescent mushrooms that grow in dark caves of any game: Minetest Game, Mineclonia and VoxeLibre.

- **Glowshroom:** a small, softly glowing mushroom (light 6) found on cave floors below y = −16. In darkness it slowly spreads to nearby cave floors, up to 6 per small area.
- **Glowshroom Lamp:** craft four glowshrooms around a glass block for a bright (light 13), cold-light block.
- Glowshrooms also burn as a little fuel.

Crafting the lamp:

```
.  G  .
G  #  G      G = Glowshroom, # = glass (from your game, via xcompat)
.  G  .
```

## Games

Tested headlessly in Minetest Game, Mineclonia and VoxeLibre (CI: engine 5.10 and 5.17, random mod load order). Placement uses an `on_generated` pass instead of engine decorations, so it also works with games that generate terrain in Lua. Cave floors are recognized by the stone types of those games. Other games work if they provide `xcompat`'s materials; mushrooms just won't generate there unless their stone is added to `mapgen.lua`.

## Dependencies

- [xcompat](https://content.luanti.org/packages/mt-mods/xcompat/): cross-game sounds and materials. It's installed automatically from ContentDB.
- Optional: `default`, `mcl_core`, `mcl_deepslate` (for load order only), and `mtt` (tests).

## Settings

| Setting | Default | Meaning |
|---|---|---|
| `glowshroom_max_y` | −16 | Glowshrooms generate and spread only at or below this height |
| `glowshroom_density` | 0.004 | Chance per suitable cave-floor node when a chunk is generated |
| `glowshroom_spread` | true | Let glowshrooms spread in darkness |

## Development

Made with [avanti-luanti](https://github.com/culmat/avanti-luanti):

```sh
avanti test                    # luacheck + ldg lint + headless runs incl. mtt tests in all three games
python3 tools/make_textures.py # re-render the textures
```

## AI disclosure

This mod was produced with AI assistance (Claude): the Lua code, and the script that draws the textures. `.cdb.json` declares `ai_disclosure: GENERATED`, and [LICENSE](LICENSE) lists the assets. The maintainer reviews every change.

## License

Code: MIT. Media: CC-BY-SA-4.0. See [LICENSE](LICENSE).
