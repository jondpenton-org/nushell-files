# Calculates ELO of match teams. $in should be the full VRY table.
export def vry-match-elo [] {
  let match_table = (
    $in
      | vry-teams
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
    | par-each { |team|
        let team_ranks_total_rr = (
          if $team == 1 {
            $match_table | take 5
          } else {
            $match_table | skip 5
          }
            | select rank rr peak_rank
            | par-each { |it|
                let peak_rank = (
                  $it.peak_rank | str replace `\s\(e\da\d\)` ``
                )
                let rank_to_parse = (
                  if $it.rank != `Unranked` or $peak_rank == `Unranked` {
                    $it.rank
                  } else {
                    $peak_rank
                  }
                )
                let rr = (
                  $it.rr | into int
                )

                if $rank_to_parse in [`Iron 1`, `Unranked`] {
                  $rr
                } else {
                  let rank_parts = (
                    $rank_to_parse | split row ` `
                  )
                  let rank = $rank_parts.0
                  let rank_index = (
                    $ranks
                      | par-each --numbered { |x|
                          if $x.item == $rank {
                            $x.index
                          }
                        }
                      | $in.0
                  )
                  let rank_base_rr = (
                    $rank_index * 300
                  )
                  let tier = (
                    $rank_parts.1 | into int
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
          index: ($team - 1),
          rank_tier: $'($rank) ($tier)',
          rr: $rr,
        }
      }
    | sort-by index
}

export def vry-teams [] {
  $in
    | lines
    | skip 1
    | drop 1
    | each --numbered { |it| # Normalize column names
        if $it.index != 0 {
          $it.item
        } else {
          $it.item
            | str downcase
            | str replace -a `(\w)\s(\w)` `${1}_${2}`
        }
      }
    | where not ($it | str contains `???`) # Remove header/players divider
    | str replace --all --string `???` `???` # Clean rows
    | str trim --char `???`
    | split column `???` # Parse rows
    | str trim # Clean cells
    | headers # Finalize table
    | select `agent` `name` `rank` `rr` `peak_rank` `hs` `wr` `kd`
}
