use ../git.nu git-root
use ../helpers.nu build-flags
use rush.completion.nu [
  "nu-complete rush autoinstallers",
  "nu-complete rush projects"
]

export def rush-add [
  package: string                 # The name of the package which should be added as a dependency. A SemVer version specifier can be appended after an "@" sign.
  --all (-a): bool                # If specified, the dependency will be added to all projects.
  --caret (-c): bool              # If specified, the SemVer specifier added to the package.json will be a prepended with a "caret" specifier ("^").
  --dev (-d): bool                # If specified, the package will be added to the "devDependencies" section of the package.json
  --exact (-e): bool              # If specified, the SemVer specifier added to the package.json will be an exact version (e.g. without tilde or caret).
  --make-consistent (-m): bool    # If specified, other packages with this dependency will have their package.json files updated to use the same version of the dependency.
  --skip-update (-s): bool        # If specified, the "rush update" command will not be run after updating the package.json files.
] {
  let flags = (
    build-flags {
      all: $all,
      caret: $caret,
      dev: $dev,
      exact: $exact,
      make-consistent: $make_consistent,
      package: $package,
      skip-update: $skip_update,
    }
  )

  rush --debug add ($flags)
}

export def rush-build [
  --to (-t): string@"nu-complete rush projects"           # Builds to project and its dependencies
  --to-except (-T): string@"nu-complete rush projects"    # Builds project's dependencies
] {
  let flags = (
    build-flags {
      parallelism: `max`,
      to: $to,
      to-except: $to_except,
      verbose: true,
    }
  )

  rush --debug build ($flags)
}

export def rush-install [
  --max-install-attempts: int = 2   # Overrides the default maximum number of install attempts. The default value is 2.
  --purge (-p): bool                # Perform "rush purge" before starting the installation
] {
  let flags = (
    build-flags {
      max-install-attempts: $max_install_attempts,
      purge: $purge,
    }
  )

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
  let flags = (
    build-flags {
      full: $full,
      ignore-hooks: $ignore_hooks,
      max-install-attempts: $max_install_attempts,
      purge: $purge,
      recheck: $recheck,
    }
  )

  rush --debug update ($flags)
}

export def rush-update-autoinstaller [
  name: string@"nu-complete rush autoinstallers"    # Specifies the name of the autoinstaller, which must be one of the folders under common/autoinstallers.
] {
  let flags = (
    build-flags {
      name: $name,
    }
  )

  rush update-autoinstaller ($flags)
}
