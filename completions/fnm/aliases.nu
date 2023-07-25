export def 'nu-complete fnm aliases' [] {
  ls (fnm-dir | path join aliases)
    | $in.name
    | path basename
    | sort
}
