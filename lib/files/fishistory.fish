# This is the fish function that will actually keep track of your commands

# Utilizes the preexec and postexec hooks added here: https://github.com/fish-shell/fish-shell/pull/1666

function fishistory

  # TODO: This could cause problems with accurately tracking time when you have multiple
  # terminals. Not sure though, needs to be tested.

  # This runs before a command is run; stores a global start time variable.
  function pre_command --on-event fish_preexec
    set -gx start_time (timestamp)
  end

  # This runs after a command is run, and writes the command data
  # to the current fishistory file.
  function post_command --on-event fish_postexec
    set -x rc $status
    set -x end_time (timestamp)
    set -x hostname (hostname)
    set -x file ~/.config/fish/fishistory/(today)
    if [ $argv ]
      printf "- cmd: $argv\n  start: $start_time\n  end: $end_time\n  rc: $rc\n  host: $hostname\n" >> $file.txt
    end
    set -e start_time
  end

  function timestamp
    echo (date +%s)
  end

  function today
    echo (date +%Y%m%d)
  end
end

