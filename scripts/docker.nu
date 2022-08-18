# Depends on overlays: helpers

## Commands
# Can only be used on Mac
export def docker-restart [] {
  echo 'Stopping Docker...';

  osascript -e 'tell application "Docker" to quit';
  sleep-while {
    not (ps | where name =~ Docker | empty?)
  };

  echo 'Starting Docker...';
  
  ^open -a Docker;
  sleep-while {
    run-external --redirect-stdout --redirect-stderr docker ps | empty?
  };

  echo 'Docker restarted.'
}

## Aliases
export alias dps = docker ps
export alias dr = docker-restart
