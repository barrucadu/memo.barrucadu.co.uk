#!/usr/bin/env python3

import sys

from t5secdatlib import *

SYLEA_VLAND_J2 = ["0236", "0437", "0638", "0740", "0940"]
SYLEA_VLAND_J1 = ["0136", "0337", "0639", "0840"]
POCKET_TRADERS = ["0235", "0232", "0728", "1032", "0936"]
CAPITAL_WORLDS = ["0134", "0626", "0934", "2736", "2025", "3113", "1514", "1311"]
BLESSED_WORLDS = ["0236"]

WORLDS = parse_world_data_from_file(sys.argv[1])

def kill_world(world, starport_chance = 0.25):
    world.starport_quality = 14 if random.random() < starport_chance else 0
    world.population = 0
    world.government_type = 0
    world.law_level = 0
    world.tech_level = 0

def tweak_uwp(world, kill_unaligned_world_chance = 0.25, kill_aligned_world_chance = 0.05):
    kill_unaligned_world = all([
        world.a == '--',
        random.random() < kill_unaligned_world_chance,
    ])
    kill_aligned_world = all([
        world.a != '--',
        random.random() < kill_aligned_world_chance,
        world.hex not in SYLEA_VLAND_J2,
        world.hex not in SYLEA_VLAND_J1,
        world.hex not in POCKET_TRADERS,
        world.hex not in CAPITAL_WORLDS,
        world.hex not in BLESSED_WORLDS,
    ])
    if kill_unaligned_world or kill_aligned_world:
        kill_world(world)

    world.population = roll_population()
    if world.a != '--':
        world.population += 1

    world.government_type = roll_government_type(world.population)
    world.law_level = roll_law_level(world.population)

    world.starport_quality = roll_starport_quality(world.population)
    # for starports, higher is worse, except for 0 which is the worst
    if world.hex in BLESSED_WORLDS:
        world.starport_quality = 10
    elif world.hex in SYLEA_VLAND_J2:
        if world.starport_quality == 0:
            world.starport_quality = 11
        else:
            world.starport_quality = min(11, world.starport_quality)
    elif world.hex in SYLEA_VLAND_J1 or world.hex in CAPITAL_WORLDS or world.hex in POCKET_TRADERS:
        if world.starport_quality == 0:
            world.starport_quality = 12
        else:
            world.starport_quality = min(12, world.starport_quality)

    # no min tech level for POCKET_TRADERS: they're just trade route endpoints,
    # there's not necessarily anything in those systems other than a starport
    # people can refuel at before heading deeper into the cluster
    world.tech_level = roll_tech_level(world.planet_size, world.atmosphere_type, world.hydrographics, world.population, world.government_type, world.starport_quality)
    if world.hex in BLESSED_WORLDS or world.hex in CAPITAL_WORLDS:
        world.tech_level = max(10, world.tech_level)
    elif world.hex in SYLEA_VLAND_J2:
        world.tech_level = max(8, world.tech_level)
    elif world.hex in SYLEA_VLAND_J1:
        world.tech_level = max(6, world.tech_level)
    elif world.a != '--':
        world.tech_level += 1
    world.tech_level = min(12, world.tech_level)

for world in WORLDS.values():
    old_uwp = world.uwp
    tweak_uwp(world)
    print(f"sed -i 's/^\\({world.hex}.*\\){old_uwp} {world.remarks}/\\1{world.uwp} {' '.join(world.trade_codes())}/' lishun-sector-data.txt")
