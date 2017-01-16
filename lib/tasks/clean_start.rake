desc "Restarts the app to be like new"
task clean_start: :environment do

  # Delete all
  Comment.delete_all
  Vote.delete_all
  Proposition.delete_all
  Birthday.delete_all
  User.delete_all

  # Seed things
  Rake::Task['db:seed'].invoke

end
