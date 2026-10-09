# Dungeon Survivor - Game Plan

A plan for a first complete Godot game.

## The Game

A top-down arena survivor in the style of Vampire Survivors. The player only moves; weapons fire automatically. Enemies pour in from every direction and grow in number. Killed enemies drop XP gems, and each level-up pauses the game to offer three random upgrades. A run lasts 10 minutes and ends with a boss. The fun is growing from fragile to a screen-clearing powerhouse in a single run.

> **Core loop:** move → kill → collect XP → pick upgrade → survive harder waves → repeat until you die or the timer ends.

## Definition of Done

The game ships when every item below is true. Cut features before cutting any of these.

- [ ] Title screen with Play, Settings and Quit
- [ ] Settings menu with at least master, music and SFX volume (saved between sessions)
- [ ] Pause menu during a run
- [ ] Win state (survive 10 minutes / beat the boss) and lose state (HP reaches 0)
- [ ] Results screen showing time survived, kills and level reached
- [ ] Best run saved to disk
- [ ] Music and sound effects throughout
- [ ] Basic juice: hit flash, screen shake, damage numbers
- [ ] Exported build uploaded to itch.io and played by at least one other person

## Scope

### Minimum content

| Category | Content |
|---|---|
| Player | One character with HP, movement speed and pickup radius |
| Weapons (3–4) | Projectile at nearest enemy; orbiting blade; area pulse around player; piercing beam |
| Passives (4–5) | Move speed, damage, cooldown, max HP, pickup radius |
| Enemies (3–4) | Basic chaser; fast and weak; slow tank; ranged shooter |
| Boss | One boss or final swarm at the 10-minute mark |
| Map | Infinite scrolling ground with optional scattered props |

### Stretch goals (only after the game is shippable)

- [ ] Weapon evolutions: a max-level weapon plus a specific passive transforms into a stronger version
- [ ] Meta-progression: currency earned per run unlocks permanent upgrades
- [ ] Multiple playable characters with different starting weapons
- [ ] A unique twist of your own (theme or mechanic) so it is more than a clone

## Project Setup

### Assets (all CC0 from Kenney)

| Pack | Used for |
|---|---|
| Tiny Dungeon | Player, enemies, weapon sprites, upgrade icons, floor tile for the ground |
| Pixel UI Pack | Menus, buttons, HUD and the level-up screen |
| Particle Pack | Hit effects, deaths, explosions |
| Impact Sounds / Interface Sounds | Combat audio and UI clicks |

### Project settings for 16×16 pixel art

- [x] Rendering → Textures → Default Texture Filter: **Nearest**
- [x] Display → Window: base size 384×216 (a 16:9 size that scales cleanly to common resolutions)
- [x] Stretch mode **canvas_items**, aspect **keep**, scale mode **integer**
- [x] Window override size 2304×1296 (6× the base size) so it opens at a usable size on high-DPI desktops

## Architecture

| Piece | Approach |
|---|---|
| Data | Custom `Resource` classes for `WeaponData`, `UpgradeData` and `EnemyData` so balancing is data edits, not code edits |
| Weapons | Child nodes of the player; each manages its own cooldown and firing logic |
| Run state | An autoload (e.g. `GameState`) holding XP, level, timer, kills |
| Events | Signals such as `enemy_died`, `xp_collected`, `leveled_up`, `player_died` |
| Collisions | `Area2D` hitboxes and hurtboxes; collision layers for player, enemies, projectiles, pickups |
| Enemy movement | Simple steering toward the player; no pathfinding needed |
| Level-up pause | `get_tree().paused = true`; the upgrade UI uses `process_mode = ALWAYS` |
| Performance | Pool enemies, projectiles and gems; watch the profiler from Phase 2 onward |
| Save data | `ConfigFile` for settings and best run in `user://` |

## Milestones

Each phase ends with something playable. Don't start the next phase until the current one meets its done condition.

### Phase 1: Movement and the infinite map

*Goal:* The player can roam forever in a world that feels endless.

- [x] Player scene with 8-direction movement (`CharacterBody2D` with a single-frame `Sprite2D` wizard, animated in code with a hop, tilt and squash because Tiny Dungeon has one frame per character)
- [x] `Camera2D` as a child of the player
- [x] Camera position smoothing
- [x] Tiling ground via `Parallax2D` with `repeat_size` set to the size of the repeating region (2048×2048)
- [ ] Debug overlay on a `CanvasLayer`: world position, enemy count, FPS

**Done when:** You can walk in any direction for minutes with no visible edge or seam.

### Phase 2: First enemy and first weapon

*Goal:* The smallest version of the game that is actually a game.

- [ ] Basic chaser enemy that steers toward the player
- [ ] Spawn ring: enemies spawn on a circle just outside the screen (see [Appendix](#appendix-spawn-ring))
- [ ] Spawns biased toward the player's movement direction
- [ ] Distant enemies recycled back onto the spawn ring instead of freed
- [ ] First weapon: auto-fires a projectile at the nearest enemy
- [ ] Player HP, contact damage, and a placeholder death

**Done when:** Enemies always arrive from off-screen, you can kill them, they can kill you, and enemy count stays stable when you run.

### Phase 3: XP and leveling

*Goal:* The progression loop works end to end.

- [ ] Enemies drop XP gems; gems drift to the player within the pickup radius
- [ ] XP bar and level on the HUD
- [ ] Level-up pauses the game and shows 3 random upgrade cards
- [ ] Upgrades defined as Resources and applied to the player or weapons
- [ ] Distant uncollected gems cleaned up or merged

**Done when:** Leveling up feels rewarding and the chosen upgrade has a visible effect.

### Phase 4: Content

*Goal:* All minimum-scope weapons, passives and enemies are in.

- [ ] Remaining weapons: orbiting blade, area pulse, piercing beam
- [ ] All passive upgrades
- [ ] Fast, tank and ranged enemy types
- [ ] Weapon and passive level caps with sensible upgrade card weighting
- [ ] Object pooling for enemies, projectiles and gems

**Done when:** Different upgrade choices lead to noticeably different runs, with no FPS drops during heavy waves.

### Phase 5: Structure of a run

*Goal:* A run has a beginning, a rising curve and an end.

- [ ] Wave director: spawn rate and enemy mix scale over the 10-minute timer
- [ ] Boss (or final swarm) at 10:00
- [ ] Win and lose states leading to a results screen
- [ ] Best run saved and shown on the title screen

**Done when:** A full run is playable start to finish and feels like it builds to a climax.

### Phase 6: Shell and polish

*Goal:* It looks, sounds and feels like a real game.

- [ ] Title screen, settings menu (volumes saved), pause menu
- [ ] Music and SFX for attacks, hits, pickups, level-ups, UI
- [ ] Juice: hit flash shader, screen shake, damage numbers, death particles
- [ ] Optional scattered props spawned and recycled around the camera

**Done when:** Someone who has never seen it can launch, play and quit without your help.

### Phase 7: Balance and ship

*Goal:* Get it in front of players.

- [ ] 10-minute stress test: run in a straight line, then in circles; FPS and memory stay flat
- [ ] Balance pass on enemy HP, spawn rates and upgrade values
- [ ] Export for Windows and Web (HTML5)
- [ ] itch.io page with screenshots and a short description
- [ ] Get at least one person to play it and note what confuses them

**Done when:** The game is public and the Definition of Done checklist is complete.

## Appendix: Spawn Ring

Pick a random point on an invisible circle centered on the player, slightly larger than the screen. Using half the screen diagonal ensures the circle clears even the corners, so nothing pops in on camera. If the camera is zoomed, divide the viewport size by the zoom.

```gdscript
func get_spawn_position() -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	# Half the screen diagonal reaches the corners; add a margin
	var radius: float = viewport_size.length() / 2.0 + 64.0
	var angle: float = randf() * TAU
	return player.global_position + Vector2.RIGHT.rotated(angle) * radius
```

To bias spawns toward the movement direction, blend the random angle with the angle of the player's velocity, e.g. pick the movement angle plus a random offset of ±90° most of the time.

---

> **Golden rule:** shipping a tiny polished game teaches far more than abandoning an ambitious one at 70%. When in doubt, cut scope.
