####################################################################################################
#                                                                                                  #
#                                          MATH UTILITIES                                          #
#                                                                                                  #
####################################################################################################
#                                                                                                  #
# This utility provides multiple procedure scripts meant to provide math-related functions that    #
#   may not be necessarily directly supported through Denizen.                                     #
#                                                                                                  #
# See the scripts for more details on how to use them.                                             #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
####################################################################################################




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     force_round_number
#
# [PROC SYNTAX]==>
#     <proc[force_round_number].context[<DECIMAL>|<INT>]>
#
# [RETURNS]==>
#     Element(Decimal)
#     The decimal specified (<DECIMAL>), force rounded to <INT> decimal places. Appends additional
#       zeroes to the end until the required amount of decimal places is met.
#
#
# [USAGE EXAMPLES]==>
#     To get "10.0000" from "10":
#       <proc[force_round_number].context[10|4]>
#
#     To get "15.60" from "15.6":
#       <proc[force_round_number].context[15.6|2]>
#
#     To get "10.40" from "10.399":
#       <proc[force_round_number].context[10.399|2]>
#
#
#

force_round_number:
  type: procedure
  debug: false
  definitions: decimal|places
  script:
  - if !<def[decimal].is_decimal||false> || <def[places].as_decimal.contains_any_text[.|-]||true>:
    - debug ERROR "Invalid number input! Expected: <#.#>|<#>. Received: <def[raw_context]> <&nl>Note: The second number should be a positive integer."
    - determine null

  - if <def[places]> <= 0:
    - determine <def[decimal].round>

  - if <def[places]> > 9:
    - debug ERROR "Limiting forced rounding to 9 decimal places. Attempting to force round a number above 10 decimal places
      will result in inaccuracies produced by Java float/double handling."
    - define places 9

  - if !<def[decimal].contains_text[.]>:
    - determine <def[decimal]>.<element[].pad_right[<def[places]>].with[0]>

  - define decimal <def[decimal].round_to[<def[places]>]>
  - determine <def[decimal].before[.]>.<def[decimal].after[.].pad_right[<def[places]>].with[0]>




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     stats_median
#
# [PROC SYNTAX]==>
#     <proc[stats_median].context[<DECIMAL>|...]>
#
# [RETURNS]==>
#     Element(Decimal)
#     Returns the median of the list of numbers.
#
#
# [USAGE EXAMPLES]==>
#     To get "10" from "10|12|1":
#       <proc[stats_median].context[10|12|1]>
#
#     To get "11" from "10|12|2|15":
#       <proc[stats_median].context[10|12|2|15]>
#
#
#

stats_median:
  type: procedure
  debug: false
  script:
  - define list <list[<def[raw_context]>].filter[is_decimal]>

  - if <def[list].is_empty>:
    - debug ERROR "The input must be a list of at least one decimal/number!"
    - determine null

  - define list <def[list].numerical>
  - define midpoint <def[list].size.div[2].round_up>

  - if <def[list].size.mod[2]> != 0:
    - determine <def[list].get[<def[midpoint]>]>

  - determine <def[list].get[<def[midpoint]>].add[<def[list].get[<def[midpoint].add[1]>]>].div[2]>




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     stats_mode
#
# [PROC SYNTAX]==>
#     <proc[stats_mode].context[<DECIMAL>|...]>
#
# [RETURNS]==>
#     Element(Decimal)
#     Returns the mode of the list of numbers.
#     If there is no mode, this will return null.
#
#
# [USAGE EXAMPLES]==>
#     To get "10" from "-40|2|10|10|2|1|10|5|10":
#       <proc[stats_mode].context[-40|2|10|10|2|1|10|5|10]>
#
#
#

stats_mode:
  type: procedure
  debug: false
  script:
  - define list <list[<def[raw_context]>].filter[is_decimal]>

  - if <def[list].is_empty>:
    - debug ERROR "The input must be a list of at least one decimal/number!"
    - determine null

  - define dedup <def[list].deduplicate>
  - define count <list[]>
  - foreach <def[dedup]> as:num:
    - define count <def[count].include[<def[num]>/<def[list].count[<def[num]>]>]>

  - if <def[count].get_sub_items[2].count[<def[count].get[1].after[/]>]> == <def[count].size>:
    - determine null

  - determine <def[count].sort_by_number[after[/]].last>




#
# __________________________________________________________________________________________________
#
# [NAME]==>
#     stats_std_dev
#
# [PROC SYNTAX]==>
#     <proc[stats_deviation].context[({population:}/sample:)<DECIMAL>|...]>
#
# [RETURNS]==>
#     Element(Decimal)
#     Returns the standard deviation of the list of numbers.
#
# [DESCRIPTION]==>
#     Calculates the standard deviation of a list of numbers.
#     If the "sample:" prefix is used, then the sample standard deviation will be calculated.
#     If the "population:" prefix is used, then the population standard deviation will be
#       calculated.
#     Defaults to calculating the population standard deviation.
#
#
# [USAGE EXAMPLES]==>
#     To calculate the population standard deviation of a list of 5 numbers:
#       <proc[stats_std_dev].context[6|3|60.3|40.325|30.424]>
#
#     To calculate the sample standard deviation of a list of 7 numbers:
#       <proc[stats_std_dev].context[sample:10|3|12|6|11|10|5]>
#
#
#

stats_std_dev:
  type: procedure
  debug: false
  script:
  - if <def[raw_context].contains[:]>:
    - define prefix <def[raw_context].before[:]>

  - define list <list[<def[raw_context].after[<def[prefix]||>:]>].filter[is_decimal]>

  - if <def[list].is_empty>:
    - debug ERROR "The input must be a list of at least one number!"
    - determine null

  - define average <def[list].sum.div[<def[list].size>]>
  - define sigma <def[list].parse[sub[<def[average]>].power[2]].sum>

  - if <def[prefix]||null> == "sample":
    - determine <def[sigma].div[<def[list].size.sub[1]>].sqrt>

  - if !<list[sample|population].contains[<def[prefix]||null>]> && <def[raw_context].contains[:]>:
    - debug ERROR "Option <&dq><def[prefix]><&dq> is not <&dq>sample<&dq> or <&dq>population<&dq>. Defaulting to calculating the
      population standard deviation."

  - determine <def[sigma].div[<def[list].size>].sqrt>
