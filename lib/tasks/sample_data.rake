namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
  
    make_relationships
  end
end



def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end