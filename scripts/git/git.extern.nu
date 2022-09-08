use git.completion.nu ["nu-complete git branches", "nu-complete git branches"]

export extern "git checkout" [
  branch?: string@"nu-complete git branches"    # name of the branch to checkout
  --conflict: string                            # conflict style (merge or diff3)
  --detach (-d)                                 # detach HEAD at named commit
  --force (-f)                                  # force checkout (throw away local modifications)
  --guess                                       # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                      # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                   # do not limit pathspecs to sparse entries only
  --merge (-m)                                  # perform a 3-way merge with the new branch
  --orphan: string                              # new unparented branch
  --ours (-2)                                   # checkout our version for unmerged files
  --overlay                                     # use overlay mode (default)
  --overwrite-ignore                            # update ignored files (default)
  --patch (-p)                                  # select hunks interactively
  --pathspec-from-file: string                  # read pathspec from file
  --progress                                    # force progress reporting
  --quiet (-q)                                  # suppress progress reporting
  --recurse-submodules: string                  # control recursive updating of submodules
  --theirs (-3)                                 # checkout their version for unmerged files
  --track (-t)                                  # set upstream info for new branch
  -b: string                                    # create and checkout a new branch
  -B: string                                    # create/reset and checkout a branch
  -l                                            # create reflog for new branch
]

export extern "git push" [
  remote?: string@"nu-complete git remotes",    # the name of the remote
  refspec?: string@"nu-complete git branches"   # the branch / refspec
  --all                                         # push all refs
  --atomic                                      # request atomic transaction on remote side
  --delete (-d)                                 # delete refs
  --dry-run (-n)                                # dry run
  --exec: string                                # receive pack program
  --follow-tags                                 # push missing but relevant tags
  --force (-f)                                  # force updates
  --force-with-lease: string                    # require old value of ref to be at this value
  --ipv4 (-4)                                   # use IPv4 addresses only
  --ipv6 (-6)                                   # use IPv6 addresses only
  --mirror                                      # mirror all refs
  --no-verify                                   # bypass pre-push hook
  --porcelain                                   # machine-readable output
  --progress                                    # force progress reporting
  --prune                                       # prune locally removed refs
  --push-option (-o): string                    # option to transmit
  --quiet (-q)                                  # be more quiet
  --receive-pack: string                        # receive pack program
  --recurse-submodules: string                  # control recursive pushing of submodules
  --repo: string                                # repository
  --set-upstream (-u)                           # set upstream for git pull/status
  --signed: string                              # GPG sign the push
  --tags                                        # push tags (can't be used with --all or --mirror)
  --thin                                        # use thin pack
  --verbose (-v)                                # be more verbose
]