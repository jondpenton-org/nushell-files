export def "nu-complete prettier arrow-parens" [] {
  [`always`, `avoid`]
}

export def "nu-complete prettier config-precedence" [] {
  [`cli-override`, `file-override`, `prefer-file`]
}

export def "nu-complete prettier embedded-language-formatting" [] {
  [`auto`, `off`]
}

export def "nu-complete prettier end-of-line" [] {
  [`auto`, `cr`, `crlf`, `lf`]
}

export def "nu-complete prettier html-whitespace-sensitivity" [] {
  [`css`, `ignore`, `strict`]
}

export def "nu-complete prettier loglevel" [] {
  [`debug`, `error`, `log`, `silent`, `warn`]
}

export def "nu-complete prettier parser" [] {
  [
    `angular`, `babel`, babel-`flow`, babel-`ts`, `css`, `espree`, `flow`,
    `glimmer`, `graphql`, `html`, `json`, `json-stringify`, `json5`, `less`,
    `lwc`, `markdown`, `mdx`, `meriyah`, `scss`, `typescript`, `vue`, `yaml`,
  ]
}

export def "nu-complete prettier prose-wrap" [] {
  [`always`, `never`, `preserve`]
}

export def "nu-complete prettier quote-props" [] {
  [`as-needed`, `consistent`, `preserve`]
}

export def "nu-complete prettier trailing-comma" [] {
  [`all`, `es5`, `none`]
}
