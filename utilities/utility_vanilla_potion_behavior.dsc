####################################################################################################
#                                                                                                  #
#                                     VANILLA POTION BEHAVIOR                                      #
#                                                                                                  #
####################################################################################################
#
# This utility allows people to quickly apply potion effects to an entity while respecting the
# vanilla potion effect rules.
#
#
# ----| PREREQUISITES
#
# (Optional) Set "Tags.Timeout" to 0. This may increase the speed of the script and reduce lag spent
# by the Denizen engine in parsing the tags (in the scripts).
#
#
# ----| HOW TO USE
#
# It is as simple as running a single run command:
# - run suscript_utility_vpb def:<dEntity>|<EFFECT>/<EFFECT>/...)
#
# Each <EFFECT> follows the format:
#   - SPIGOT_POTION_EFFECT,<power>,<duration>,<hide_ambience>,<hide_particles>
#
# SPIGOT_POTION_EFFECT : A valid Spigot potion effect. A list can be found here:
#                        https://hub.spigotmc.org/javadocs/spigot/org/bukkit/potion/PotionEffectType.html
# power                : The power of the effect
# duration             : The duration of the effect, in ticks
# hide_ambience        : Whether or not to hide the ambience. Must be a boolean.
# hide_particles       : Whether or not to hide the particles. Overrides hide_ambience. Must be a
#                        boolean.
#
#
#





# -----------------------------------------------
#
# Vanilla Potion Behavior Task
#
# - Applies a potion effect to an entity while following vanilla rules
#
#

vanilla_potion_effect_utility:
  type: task
  debug: false
  speed: 0
  definitions: entity|pot_effects

  script:
  - if !<server.entity_is_spawned[<def[entity]>]>:
    - debug ERROR "The entity provided is not spawned or living!"
    - stop

  - foreach <def[pot_effects].split[/]> as:input:
    - if !<def[input].matches[[A-Za-z_]+,[0-9]+,[0-9]+,(true|false),(true|false)]>:
      - debug ERROR "Invalid potion effect [<def[input]>]! The correct format is <&dq>EFFECT,DURATION,POWER,AMBIENT,HIDE_PARTICLES<&dq>."
      - foreach next

    - define effect <def[input].split[,].1>
    - if !<server.list_potion_effects.contains[<def[effect]>]>:
      - debug ERROR "<&dq><def[effect]><&dq> is not a valid Spigot status effect!"
      - foreach next

    - define duration <def[input].split[,].2>
    - define power <def[input].split[,].3>
    - define ambient <def[input].split[,].4>
    - define hide_particles <def[input].split[,].5>

    - define effect_index <def[entity].list_effects.parse[before[,]].find[<def[effect]>]||-1>
    - if <def[effect_index]> > 0 && ( <def[entity].list_effects.get[<def[effect_index]>].split[,].2> > <def[duration]> || <def[entity].list_effects.get[<def[effect_index]>].split[,].3> > <def[power]> ):
      - foreach next

    - if <def[ambient]> && <def[hide_particles]>:
      - cast <def[effect]> <def[entity]> duration:<def[duration]> power:<def[power]> no_ambient hide_particles
    - else if <def[ambient]>:
      - cast <def[effect]> <def[entity]> duration:<def[duration]> power:<def[power]> no_ambient
    - else if <def[hide_particles]>:
      - cast <def[effect]> <def[entity]> duration:<def[duration]> power:<def[power]> hide_particles
    - else:
      - cast <def[effect]> <def[entity]> duration:<def[duration]> power:<def[power]>
