# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name: "Patryk Peas", email: "patryk.peas@monterail.com",
	sso_id: "peas123", birthday_month: 1, birthday_day: 2)
User.create!(name: "Szymon Boniecki", email: "szymon@monterail.com",
	sso_id: "szymon123", birthday_month: 1, birthday_day: 12)
User.create!(name: "Katarzyna Byndas", email: "katarzyna.byndas@monterail.com",
	sso_id: "kasia123", birthday_month: 1, birthday_day: 19)
User.create!(name: "Katarzyna Tatomir", email: "katarzyna.tatomir@monterail.com",
	sso_id: "kotarzyna", birthday_month: 1, birthday_day: 21)
User.create!(name: "Łukasz Potępa", email: "lukasz.potepa@monterail.com",
	sso_id: "lukasz123", birthday_month: 2, birthday_day: 3)
User.create!(name: "Paweł Rutkowski", email: "pawel.rutkowski@monterail.com",
	sso_id: "ruto", birthday_month: 2, birthday_day: 14)
User.create!(name: "Bartosz Pietrzak", email: "bartosz.pietrzak@monterail.com",
	sso_id: "bartosz", birthday_month: 3, birthday_day: 9)
User.create!(name: "Jan Dudulski", email: "jan.dudulski@monterail.com",
	sso_id: "janek", birthday_month: 4, birthday_day: 8)
User.create!(name: "Radek Markiewicz", email: "radek.markiewicz@monterail.com",
	sso_id: "radomark", birthday_month: 4, birthday_day: 24)
User.create!(name: "Dariusz Gertych", email: "dariusz.gertych@monterail.com",
	sso_id: "dariusz", birthday_month: 5, birthday_day: 18)
User.create!(name: "Darya Stepanyan", email: "darya.stepanyan@monterail.com",
	sso_id: "darya", birthday_month: 6, birthday_day: 3)
User.create!(name: "Tobiasz Waszak", email: "tobiasz.waszak@monterail.com",
	sso_id: "tobiasz", birthday_month: 6, birthday_day: 4)
User.create!(name: "Natalia Szczepkowska", email: "natalia.szczepkowska@monterail.com",
	sso_id: "natalia", birthday_month: 6, birthday_day: 11)
User.create!(name: "Kamila Jędrysiak", email: "kamila.jedrysiak@monterail.com",
	sso_id: "kamila", birthday_month: 6, birthday_day: 20)
User.create!(name: "Tymon Tobolski", email: "tymon.tobolski@monterail.com",
	sso_id: "timmy", birthday_month: 6, birthday_day: 22)
User.create!(name: "Lidia Karpińska", email: "lidia.karpinska@monterail.com",
	sso_id: "lidia", birthday_month: 6, birthday_day: 30)
User.create!(name: "Łukasz Wnęk", email: "lukasz.wnek@monterail.com",
	sso_id: "paolo", birthday_month: 7, birthday_day: 12)
User.create!(name: "Marzena Kawa", email: "marzena.kawa@monterail.com",
	sso_id: "marzena", birthday_month: 10, birthday_day: 1)
User.create!(name: "Adam Hodowany", email: "adam.hodowany@monterail.com",
	sso_id: "hodak", birthday_month: 12, birthday_day: 24)
User.create!(name: "Damian Dulisz", email: "damian.dulisz@monterail.com",
	sso_id: "damian", birthday_month: 12, birthday_day: 30)