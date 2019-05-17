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
  - if <[decimal]||null> !matches decimal || <[places].as_decimal.contains_any_text[.|-]||true>:
    - debug ERROR "Invalid number input! Expected: <#.#>|<#>. Received: <[raw_context]> <n>Note: The second number should be a positive integer."
    - determine null

  - if <[places]> <= 0:
    - determine <[decimal].round>

  - if <[places]> > 9:
    - debug ERROR "Limiting forced rounding to 9 decimal places. Attempting to force round a number above 10 decimal places
      will result in inaccuracies produced by Java float/double handling."
    - define places 9

  - if !<[decimal].contains_text[.]>:
    - determine <[decimal]>.<element[].pad_right[<[places]>].with[0]>

  - define decimal <[decimal].round_to[<[places]>]>
  - determine <[decimal].before[.]>.<[decimal].after[.].pad_right[<[places]>].with[0]>




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
#     To get "10.0" from "10":
#       <proc[sigfig].context[10|3]>
#
#     To get "15.60" from "15.598432":
#       <proc[sigfig].context[15.598432|4]>
#
#     To get "1200" from "1199":
#       <proc[sigfig].context[1199|2]>
#
#
#

stats_median:
  type: procedure
  debug: false
  script:
  - define list <list[<[raw_context]>].filter[is[matches].to[decimal]]>

  - if <[list].is_empty>:
    - debug ERROR "The input must be a list of at least one decimal/number!"
    - determine null

  - define list <[list].numerical>
  - define midpoint <[list].size./[2].round_up>

  - if <[list].size.%[2]> != 0:
    - determine <[list].get[<[midpoint]>]>

  - determine <[list].get[<[midpoint]>].+[<[list].get[<[midpoint].+[1]>]>]./[2]>




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
  - if <[raw_context].contains[:]>:
    - define prefix <[raw_context].before[:]>

  - define list <list[<[raw_context].after[<[prefix]||>:]>].filter[is[matches].to[decimal]]>

  - if <[list].is_empty>:
    - debug ERROR "The input must be a list of at least one number!"
    - determine null

  - define average <[list].sum./[<[list].size>]>
  - define sigma <[list].parse[sub[<[average]>].^[2]].sum>

  - if <[prefix]||null> == "sample":
    - determine <[sigma]./[<[list].size.-[1]>].sqrt>

  - if !<list[sample|population].contains[<[prefix]||null>]> && <[raw_context].contains[:]>:
    - debug ERROR "Option <&dq><[prefix]><&dq> is not <&dq>sample<&dq> or <&dq>population<&dq>. Defaulting to calculating the
      population standard deviation."

  - determine <[sigma]./[<[list].size>].sqrt>
