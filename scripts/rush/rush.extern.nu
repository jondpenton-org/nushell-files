use modules/git/git-root.nu
use scripts/rush/rush.completion.nu 'nu-complete rush projects'

# TODO: Remove
def 'nu-complete rush projects' [] {
  let config_path = git-root | path join rush.json

  if not ($config_path | path exists) {
    return []
  }

  (open $config_path).projects.packageName
}

export extern "rush add" [
  --all (-a): bool # If specified, the dependency will be added to all projects.
  --caret (-c): bool # If specified, the SemVer specifier added to the package.json will be a prepended with a "caret" specifier ("^").
  --dev (-d): bool # If specified, the package will be added to the "devDependencies" section of the package.json
  --exact (-e): bool # If specified, the SemVer specifier added to the package.json will be an exact version (e.g. without tilde or caret).
  --make-consistent (-m): bool # If specified, other packages with this dependency will have their package.json files updated to use the same version of the dependency.
  --package (-p): string # The name of the package which should be added as a dependency. A SemVer version specifier can be appended after an "@" sign.
]

# This command builds projects in order of dependencies.
export extern "rush build" [
  --parallelism (-p): any # Specifies the maximum number of concurrent processes to launch during a build. The COUNT should be a positive integer or else the word "max" to specify a count that is equal to the number of CPU cores. If this parameter is omitted, then the default value depends on the operating system and number of CPU cores. This parameter may alternatively be specified via the RUSH_PARALLELISM environment variable.
  --to (-t): string@'nu-complete rush projects' # Builds to project and its dependencies
  --to-except (-T): string@'nu-complete rush projects' # Builds project's dependencies
  --verbose (-v): bool # Display the logs during the build, rather than just displaying the build status summary
]

# The "rush install" command installs package dependencies for all your projects, based on the shrinkwrap file that is created/updated using "rush update". (This "shrinkwrap" file stores a central inventory of all dependencies and versions for projects in your repo. It is found in the "common/config/rush" folder.) If the shrinkwrap file is missing or outdated (e.g. because project package.json files have changed), "rush install" will fail and tell you to run "rush update" instead. This read-only nature is the main feature: Continuous integration builds should use "rush install" instead of "rush update" to catch developers who forgot to commit their shrinkwrap changes. Cautious people can also use "rush install" if they want to avoid accidentally updating their shrinkwrap file.
export extern "rush install" [
  --bypass-policy: bool # Overrides enforcement of the "gitPolicy" rules from rush.json (use honorably!)
  --check-only: bool # Only check the validity of the shrinkwrap file without performing an install.
  --debug-package-manager: bool # Activates verbose logging for the package manager. You will probably want to pipe the output of Rush to a file when using this command.
  --from (-f): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--from" parameter expands this selection to include PROJECT and all projects that depend on it, plus all dependencies of this set. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --from-version-policy: string # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. The "--from-version-policy" parameter is equivalent to specifying "--from" for each of the projects belonging to VERSION_POLICY_NAME. For details, refer to the website article "Selecting subsets of projects".
  --ignore-hooks: bool # Skips execution of the "eventHooks" scripts defined in rush.json. Make sure you know what you are skipping.
  --impacted-by (-i): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--impacted-by" parameter expands this selection to include PROJECT and any projects that depend on PROJECT (and thus might be broken by changes to PROJECT). "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --impacted-by-except (-I): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--impacted-by-except" parameter works the same as "--impacted-by" except that PROJECT itself is not added to the selection. "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --max-install-attempts: int # Overrides the default maximum number of install attempts. The default value is 3.
  --network-concurrency: int # If specified, limits the maximum number of concurrent network requests. This is useful when troubleshooting network failures.
  --no-link: bool # If "--no-link" is specified, then project symlinks will NOT be created after the installation completes. You will need to run "rush link" manually. This flag is useful for automated builds that want to report stages individually or perform extra operations in between the two stages. This flag is not supported when using workspaces.
  --only (-o): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--only" parameter expands this selection to include PROJECT; its dependencies are not added. "." can be used as shorthand for the project in the current working directory. Note that this parameter is "unsafe" as it may produce a selection that excludes some dependencies. For details, refer to the website article "Selecting subsets of projects".
  --purge (-p): bool # Perform "rush purge" before starting the installation
  --to (-t): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--to" parameter expands this selection to include PROJECT and all its dependencies. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --to-except (-T): string@'nu-complete rush projects' # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. Each "--to-except" parameter expands this selection to include all dependencies of PROJECT, but not PROJECT itself. "." can be used as shorthand for the project in the current working directory. For details, refer to the website article "Selecting subsets of projects".
  --to-version-policy: string # Normally all projects in the monorepo will be processed; adding this parameter will instead select a subset of projects. The "--to-version-policy" parameter is equivalent to specifying "--to" for each of the projects belonging to VERSION_POLICY_NAME. For details, refer to the website article "Selecting subsets of projects".
  --variant: string # Run command using a variant installation configuration. This parameter may alternatively be specified via the RUSH_VARIANT environment variable.
]
