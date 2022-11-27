#!/usr/bin/env python3

import sys

from t5secdatlib import *

CAPITAL_WORLDS = ["Uundas", "Gishgi", "Paran", "Ankii An", "Mine", "Kimuum", "Irzemuu", "Kuunguu"]

WORLDS = parse_world_data_from_file(sys.argv[1])

def kill_world(world, starport_chance = 0.25):
    world.starport_quality = 14 if random.random() < starport_chance else 0
    world.population = 0
    world.government_type = 0
    world.law_level = 0
    world.tech_level = 0

def tweak_uwp(world, kill_unaligned_world_chance = 0.10):
    if world.population == 0 or (world.a == '--' and random.random() < kill_unaligned_world_chance):
        kill_world(world)
        return

    # population: standard, +1 for human pocket empires
    world.population = roll_population()
    if world.a[0] == "H":
        world.population += 1

    # starport quality: standard
    world.starport_quality = roll_starport_quality(world.population)

    # tech level: 1 lower than standard, clamped at 12, min 10 for hub worlds
    tech_level = roll_tech_level(world.planet_size, world.atmosphere_type, world.hydrographics, world.population, world.government_type, world.starport_quality) - 1
    if world.name in CAPITAL_WORLDS:
        tech_level = max(tech_level, 10)
    world.tech_level = max(1, min(12, tech_level))

for world in WORLDS.values():
    old_uwp = world.uwp
    tweak_uwp(world)
    print(f"sed -i 's/^\\({world.hex}.*\\){old_uwp} {world.remarks}/\\1{world.uwp} {' '.join(world.trade_codes())}/' lishun-sector-data.txt")
