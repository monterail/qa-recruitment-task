# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "qa1@monterail.com", birthday_month: 1, birthday_day: 4 ,name: "Long John",sso_id: "qa1ssoid" , password: "123456")
User.create(email: "qa2@monterail.com", birthday_month: 2, birthday_day: 4 ,name: "Small John",sso_id: "qa2ssoid" , password: "123456")
User.create(email: "qa3@monterail.com", birthday_month: 3, birthday_day: 4 ,name: "Pink John",sso_id: "qa3ssoid" , password: "123456")
User.create(email: "qa4@monterail.com", birthday_month: 4, birthday_day: 9 ,name: "Red John",sso_id: "qa4ssoid" , password: "123456")
User.create(email: "qa5@monterail.com", birthday_month: 5, birthday_day: 9 ,name: "Black John",sso_id: "qa5ssoid" , password: "123456")
User.create(email: "qa6@monterail.com", birthday_month: 6, birthday_day: 9 ,name: "Green John",sso_id: "qa6ssoid" , password: "123456")
