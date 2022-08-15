## Commands

export def rush-add [
  package: string                 # The name of the package which should be added as a dependency. A SemVer version specifier can be appended after an "@" sign.
  --all (-a): bool                # If specified, the dependency will be added to all projects.
  --caret (-c): bool              # If specified, the SemVer specifier added to the package.json will be a prepended with a "caret" specifier ("^").
  --dev (-d): bool                # If specified, the package will be added to the "devDependencies" section of the package.json
  --exact (-e): bool              # If specified, the SemVer specifier added to the package.json will be an exact version (e.g. without tilde or caret).
  --make-consistent (-m): bool    # If specified, other packages with this dependency will have their package.json files updated to use the same version of the dependency.
] {
  let flags = build-flags {
    all: $all,
    caret: $caret,
    dev: $dev,
    exact: $exact,
    make-consistent: $make-consistent,
    package: $package,
  }

  rush --debug add ($flags)
}

export def rush-build [
  --to (-t): string@"nu-complete rush projects"           # Builds to project and its dependencies
  --to-except (-T): string@"nu-complete rush projects"    # Builds project's dependencies
] {
  let flags = build-flags {
    parallelism: 'max',
    to: $to,
    to-except: $to-except,
    verbose: true,
  }

  rush --debug build ($flags)
}

export def rush-install [
  --max-install-attempts: int = 2   # Overrides the default maximum number of install attempts. The default value is 2.
  --purge (-p): bool                # Perform "rush purge" before starting the installation
] {
  let flags = build-flags {
    max-install-attempts: $max-install-attempts,
    purge: $purge,
  }

  rush --debug install ($flags)
}

# The "rush update" command installs the dependencies described in your package. json files, and updates the shrinkwrap file as needed. (This "shrinkwrap" file stores a central inventory of all dependencies and versions for projects in your repo. It is found in the "common/config/rush" folder.) Note that Rush always performs a single install for all projects in your repo. You should run "rush update" whenever you start working in a Rush repo, after you pull from Git, and after you modify a package.json file. If there is nothing to do, "rush update" is instantaneous. NOTE: In certain cases "rush install" should be used instead of "rush update" -- for details, see the command help for "rush install".
export def rush-update [
  --full (-f): bool                       # Normally "rush update" tries to preserve your existing installed versions and only makes the minimum updates needed to satisfy the package.json files. This conservative approach prevents your PR from getting involved with package updates that are unrelated to your work. Use "--full" when you really want to update all dependencies to the latest SemVer-compatible version. This should be done periodically by a person or robot whose role is to deal with potential upgrade regressions.
  --ignore-hooks (-i): bool               # Skips execution of the "eventHooks" scripts defined in rush.json. Make sure you know what you are skipping.
  --max-install-attempts (-m): int = 2    # Overrides the default maximum number of install attempts. The default value is 2.
  --purge (-p): bool                      # Perform "rush purge" before starting the installation
  --recheck (-r): bool                    # If the shrinkwrap file appears to already satisfy the package.json files, then "rush update" will skip invoking the package manager at all. In certain situations this heuristic may be inaccurate. Use the "--recheck" flag to force the package manager to process the shrinkwrap file. This will also update your shrinkwrap file with Rush's fixups. (To minimize shrinkwrap churn, these fixups are normally performed only in the temporary folder.)
] {
  let flags = build-flags {
    full: $full,
    ignore-hooks: $ignore-hooks,
    max-install-attempts: $max-install-attempts,
    purge: $purge,
    recheck: $recheck,
  }

  rush --debug update ($flags)
}

export def rush-update-autoinstaller [
  name: string@"nu-complete rush autoinstallers"    # Specifies the name of the autoinstaller, which must be one of the folders under common/autoinstallers.
] {
  let flags = build-flags {
    name: $name,
  }

  rush update-autoinstaller ($flags)
}

## Aliases
export alias r-a = rush-add
export alias r-b = rush-build
export alias r-i = rush-install
export alias r-ip = rush-install --purge
export alias r-u = rush-update
export alias r-ua = rush-update-autoinstaller
export alias r-uf = rush-update --full

## Externs
# TODO: Write `extern`s for all rush commands we use

export extern "rush add" [
  --all (-a): bool                       # If specified, the dependency will be added to all projects.
  --caret (-c): bool                     # If specified, the SemVer specifier added to the package.json will be a prepended with a "caret" specifier ("^").
  --dev (-d): bool                       # If specified, the package will be added to the "devDependencies" section of the package.json
  --exact (-e): bool                     # If specified, the SemVer specifier added to the package.json will be an exact version (e.g. without tilde or caret).
  --make-consistent (-m): bool           # If specified, other packages with this dependency will have their package.json files updated to use the same version of the dependency.
  --package (-p): string                 # The name of the package which should be added as a dependency. A SemVer version specifier can be appended after an "@" sign.
]

# This command builds projects in order of dependencies.
export extern "rush build" [
  --parallelism (-p): any                                 # Specifies the maximum number of concurrent processes to launch during a build. The COUNT should be a positive integer or else the word "max" to specify a count that is equal to the number of CPU cores. If this parameter is omitted, then the default value depends on the operating system and number of CPU cores. This parameter may alternatively be specified via the RUSH_PARALLELISM environment variable.
  --to (-t): string@"nu-complete rush projects"           # Builds to project and its dependencies
  --to-except (-T): string@"nu-complete rush projects"    # Builds project's dependencies
  --verbose (-v): bool                                    # Display the logs during the build, rather than just displaying the build status summary
]

# The "rush install" command installs package dependencies for all your projects, based on the shrinkwrap file that is created/updated using "rush update". (This "shrinkwrap" file stores a central inventory of all dependencies and versions for projects in your repo. It is found in the "common/config/rush" folder.) If the shrinkwrap file is missing or outdated (e.g. because project package.json files have changed), "rush install" will fail and tell you to run "rush update" instead. This read-only nature is the main feature: Continuous integration builds should use "rush install" instead of "rush update" to catch developers who forgot to commit their shrinkwrap changes. Cautious people can also use "rush install" if they want to avoid accidentally updating their shrinkwrap file.
export extern "rush install" [
  --bypass-policy: bool                                                # Overrides enforcement of the "gitPolicy" rules from rush.json (use honorably!)
  --check-only: bool                                                   # Only check the validity of the shrinkwrap file without performing an install.
  --debug-package-manager: bool                                        # Activates verbose logging for the package manager. You will probably want to pipe the output of Rush to a file when using this command.
  --from (-f): string@"nu-complete rush projects"                      # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--from" parameter expands this selection to include PROJECT and all projects that depend on it, plus all dependencies of this set. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --from-version-policy: string                                        # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. The "--from-version-policy" parameter is equivalent to specifying "--from" for each of the projects belonging to VERSION_POLICY_NAME. For details, refer to the website article "Selecting subsets of projects".
  --ignore-hooks: bool                                                 # Skips execution of the "eventHooks" scripts defined in rush.json. Make sure you know what you are skipping.
  --impacted-by (-i): string@"nu-complete rush projects"               # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--impacted-by" parameter expands this selection to include PROJECT and any projects that depend on PROJECT (and thus might be broken by changes to PROJECT). "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --impacted-by-except (-I): string@"nu-complete rush projects"        # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--impacted-by-except" parameter works the same as "--impacted-by" except that PROJECT itself is not added to the selection. "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --max-install-attempts: int                                          # Overrides the default maximum number of install attempts. The default value is 3.
  --network-concurrency: int                                           # If specified, limits the maximum number of concurrent network requests. This is useful when troubleshooting network failures.
  --no-link: bool                                                      # If "--no-link" is specified, then project symlinks will NOT be created after the installation completes. You will need to run "rush link" manually. This flag is useful for automated builds that want to report stages individually or perform extra operations in between the two stages. This flag is not supported when using workspaces.
  --only (-o): string@"nu-complete rush projects"                      # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--only" parameter expands this selection to include PROJECT; its dependencies are not added. "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --purge (-p): bool                                                   # Perform "rush purge" before starting the installation
  --to (-t): string@"nu-complete rush projects"                        # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--to" parameter expands this selection to include PROJECT and all its dependencies. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --to-except (-T): string@"nu-complete rush projects"                 # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--to-except" parameter expands this selection to include all dependencies of PROJECT, but not PROJECT itself. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --to-version-policy: string                                          # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. The "--to-version-policy" parameter is equivalent to specifying "--to" for each of the projects belonging to VERSION_POLICY_NAME. For details, refer to the website article "Selecting subsets of projects".
  --variant: string                                                    # Run command using a variant installation configuration. This parameter may alternatively be specified via the RUSH_VARIANT environment variable.
]

## Completions

def "nu-complete rush autoinstallers" [] {
  git-root
    | path join common/autoinstallers
    | ls $in
    | get name
    | path basename
}

def "nu-complete rush projects" [] {
  git-root
    | path join rush.json
    | if not ($in | path exists) {
        []
      } else {
        open $in | get projects.packageName
      }
}
