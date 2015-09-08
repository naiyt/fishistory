# This is the config file for whenever: http://github.com/javan/whenever
# Modify this to change when the cronjob to save your history to the
# database occurs.
#
# When you make a change, run "whenever -w" to write it to your crontab

every 2.hours do
  rake 'fishistory:save'
end

