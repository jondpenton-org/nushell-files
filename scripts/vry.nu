# Calculates ELO of match teams. $in should be the full VRY table.
export def vry-match-elo [] {
  let match_table = (
    $in
      | from vry
      | where name != ``
  )
  let ranks = [
    `Iron`,
    `Bronze`,
    `Silver`,
    `Gold`,
    `Platinum`,
    `Diamond`,
    `Ascendant`,
    `Immortal`
  ]
  let teams_num = (
    ($match_table | length) / 5
  )

  1..$teams_num
    | par-each { |team_num|
        let team_ranks_total_rr = (
          if $team_num == 1 {
            $match_table | take 5
          } else {
            $match_table | skip 5
          }
            | select rank rr peak_rank
            | par-each { |it|
                let peak_rank = (
                  $it | get peak_rank | str replace `\s\(e\da\d\)` ``
                )
                let rank_to_parse = (
                  if ($it | get rank) != `Unranked` or $peak_rank == `Unranked` {
                    ($it | get rank)
                  } else {
                    $peak_rank
                  }
                )
                let rr = (
                  $it | get rr | into int
                )

                if $rank_to_parse in [`Iron 1`, `Unranked`] {
                  $rr
                } else {
                  let rank_parts = (
                    $rank_to_parse | split row ` `
                  )
                  let rank = ($rank_parts | first)
                  let rank_index = (
                    $ranks
                      | par-each { |it, index|
                          if $it == $rank {
                            $index
                          }
                        }
                      | first
                  )
                  let rank_base_rr = (
                    $rank_index * 300
                  )
                  let tier = (
                    $rank_parts | get 1 | into int
                  )

                  $rank_base_rr + (($tier - 1) * 100) + $rr
                }
              }
        )
        let average_rr = (
          $team_ranks_total_rr | math avg
        )
        let rank_division_result = (
          $average_rr / 300
        )
        let rank_index = (
          $rank_division_result
            | math floor
            | into int
        )
        let rank = (
          $ranks | get $rank_index
        )
        let tier_division_result = (
          ($rank_division_result - $rank_index) * 300 / 100
        )
        let tier = (
          ($tier_division_result | math floor) + 1
        )
        let rr = (
          ($tier_division_result - ($tier - 1)) * 100 | into int
        )

        {
          index: ($team_num - 1),
          rank_tier: $'($rank) ($tier)',
          rr: $rr,
        }
      }
    | sort-by index
}

export def "from vry" [] {
  let table = (
    $in
      | lines
      | skip 1
      | drop 1
      | each { |it, index| # Normalize column names
          when { $index == 0 } {
            str downcase | str replace --all `(\w)\s(\w)` `${1}_${2}`
          }
        }
      | where (`━` not-in $it) # Remove header/players divider
      | str replace --all --string `┃` `│` # Clean rows
      | str trim --char `│`
      | split column `│` # Parse rows
      | str trim # Clean cells
      | headers
      | filter {
          values | any { is-empty | not $in }
        }
  )
  let table = do {
    let int_keys = [rr, hs, level]

    $table | each { |it|
      $int_keys | reduce --fold $it { |key, row|
        mut value = ($row | get --ignore-errors $key)

        if ($value | is-empty) {
          $value = null
        } else {
          $value = ($value | into int)
        }

        $row | update $key $value
      }
    }
  }
  let table = (
    $table | update party { get party | $in == `■` }
  )

  $table
}
