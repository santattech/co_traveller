# lib/tasks/recurring_jobs.rake

namespace :recurring do
  task init: :environment do
    LastLocationMail.schedule!

  end
end