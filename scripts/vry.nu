# Calculates ELO of match teams. $in should be the full VRY table.
export def vry-match-elo [] {
  let match_table = (
    $in
      | lines
      | skip 2
      | where not ($it | str starts-with +-)
      | split column " | "
      | str trim --char "|"
      | str trim
      | headers
  )
  let ranks = ["Iron", "Bronze", "Silver", "Gold", "Platinum", "Diamond", "Ascendant", "Immortal"]
  for $team in [1, 2] {
    let team_ranks_total_rr = (
      if $team == 1 {
        $match_table | take 5
      } else {
        $match_table | skip 6
      }
        | select Rank RR "Peak Rank"
        | par-each { |it|
            let rank_to_parse = if $it.Rank == "Unranked" && it."Peak Rank" != "Unranked" {
              $it."Peak Rank"
            } else {
              $it.Rank
            }
            let rr = (
              $it.RR | into int
            )
  
            if not ($rank_to_parse in ["Iron 1", "Unranked"]) {
              let rank_parts = ($rank_to_parse | split row " ")
              let rank = ($rank_parts | get 0)
              let rank_index = (
                $ranks
                  | par-each -n { |x|
                      if $x.item == $rank {
                        $x.index
                      }
                    }
                  | get 0
              )
              let rank_base_rr = $rank_index * 300
              let tier = ($rank_parts | get 1 | into int)
              let total_rr = $rank_base_rr + (($tier - 1) * 100) + $rr
  
              $total_rr
            } else {
              $rr
            }
          }
    )  
    let average_rr = (
      $team_ranks_total_rr | math avg
    )
    let rank_division_result = $average_rr / 300
    let rank_index = (
      $rank_division_result | math floor | into int
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
      team: $team,
      rank-tier: $"($rank) ($tier)",
      rr: $rr,
    }
  }
}
