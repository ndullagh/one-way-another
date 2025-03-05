[33mcommit 1ec92591adbed17a5c1239677c6e06b837618cfa[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mZaidBranch[m[33m)[m
Author: The-Last-Kodiak <theseventhkodiak@gmail.com>
Date:   Tue Mar 4 13:36:59 2025 -0800

    Added enemy shooting mechanics and jump behavior

 project.godot                                      |   5 [32m+[m
 .../level 1(3 duplicate)/death_zones/area_2d.tscn  |  14 [32m++[m
 .../death_zones/area_2d_2.tscn                     |  14 [32m++[m
 .../death_zones/area_2d_3.tscn                     |  14 [32m++[m
 .../death_zones/area_2d_4.tscn                     |  14 [32m++[m
 .../death_zones/area_2d_5.tscn                     |  14 [32m++[m
 .../death_zones/area_2d_6.tscn                     |  14 [32m++[m
 scenes/main/levels/level 1(3 duplicate)/enemy.tscn |  19 [32m++[m
 .../main/levels/level 1(3 duplicate)/node_2d.tscn  | 267 [32m+++++++++++++++++++++[m
 .../levels/level 1(3 duplicate)/projectile.tscn    |  27 [32m+++[m
 .../level 1(3 duplicate)/snow_generator.tscn       |  37 [32m+++[m
 scripts/main/character_body_2d.gd                  |  26 [32m+[m[31m-[m
 scripts/main/levels/level1(3dup)/enemy.gd          |  73 [32m++++++[m
 scripts/main/levels/level1(3dup)/projectile.gd     |  12 [32m+[m
 14 files changed, 548 insertions(+), 2 deletions(-)
