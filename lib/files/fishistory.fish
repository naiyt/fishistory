function fishistory
  function preexec_test --on-event fish_preexec
    set -gx start_time (timestamp)
  end

  function postexec_test --on-event fish_postexec
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

