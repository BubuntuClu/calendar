env :PATH, ENV['PATH']

every 1.day do
  runner "DailyNotesJob.perform_now"
end
