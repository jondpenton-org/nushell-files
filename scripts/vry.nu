# Calculates ELO of match teams. $in should be the full VRY table.
export def vry-match-elo [] {
  let match-table = (
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
    let team-ranks-total-rr = (
      if $team == 1 {
        $match-table | take 5
      } else {
        $match-table | skip 6
      }
        | select Rank RR "Peak Rank"
        | par-each { |it|
            let rank-to-parse = if $it.Rank == "Unranked" && it."Peak Rank" != "Unranked" {
              $it."Peak Rank"
            } else {
              $it.Rank
            }
            let rr = (
              $it.RR | into int
            )
  
            if not ($rank-to-parse in ["Iron 1", "Unranked"]) {
              let rank-parts = ($rank-to-parse | split row " ")
              let rank = ($rank-parts | get 0)
              let rank-index = (
                $ranks
                  | par-each -n { |x|
                      if $x.item == $rank {
                        $x.index
                      }
                    }
                  | get 0
              )
              let rank-base-rr = $rank-index * 300
              let tier = ($rank-parts | get 1 | into int)
              let total-rr = $rank-base-rr + (($tier - 1) * 100) + $rr
  
              $total-rr
            } else {
              $rr
            }
          }
    )  
    let average-rr = (
      $team-ranks-total-rr | math avg
    )
    let rank-division-result = $average-rr / 300
    let rank-index = (
      $rank-division-result | math floor | into int
    )
    let rank = (
      $ranks | get $rank-index
    )
    let tier-division-result = (
      ($rank-division-result - $rank-index) * 300 / 100
    )
    let tier = (
      ($tier-division-result | math floor) + 1
    )
    let rr = (
      ($tier-division-result - ($tier - 1)) * 100 | into int
    )
  
    {
      team: $team,
      rank-tier: $"($rank) ($tier)",
      rr: $rr,
    }
  }
}
