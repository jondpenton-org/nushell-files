use ../helpers.nu sleep-while

# Can only be used on Mac
export def docker-restart [] {
  echo `Stopping Docker...`;

  osascript -e `tell application "Docker" to quit`;
  sleep-while {
    not (ps | where name =~ Docker | is-empty)
  };

  echo `Starting Docker...`;

  ^open -a Docker;
  sleep-while {
    run-external --redirect-stdout --redirect-stderr docker ps | is-empty
  };

  echo `Docker restarted.`
}
