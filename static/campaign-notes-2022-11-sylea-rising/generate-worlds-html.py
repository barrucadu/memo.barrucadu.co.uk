#!/usr/bin/env python3

import sys

from t5secdatlib import *

ALLEGIANCE_NAMES = {
    "Sy": "Sylean Federation",
    "H1": "Gishgi People's Assembly",
    "H2": "Paran League",
    "H3": "Uundas Union",
    "H4": "Kimuum Free Worlds",
    "H5": "Irzemuu Federation",
    "H6": "Kuunguu Confederation",
    "H7": "Our Kingdom",
    "H8": "Grand Duchy of Ankii An",
    "V1": "Ksouruz Pact",
    "V2": "7th Disjuncture",
    "V3": "Gzoerrghzae Fleet",
}

WORLDS = parse_world_data_from_file(sys.argv[1])

for hex in sorted(WORLDS):
    world = WORLDS[hex]
    if world.remarks == "Unsurveyed":
        continue
    print(f"<h2>{world}</h2>")
    print(world.explain(allegiance_names=ALLEGIANCE_NAMES, html=True))
