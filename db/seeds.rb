require 'bcrypt'

# ユーザ名とパスワード
# Example から変更
name = "Example"
password = "Example"
flag = true

hashed_password = BCrypt::Password.create(password)

User.create!(
      account_name: name, 
      password_digest: hashed_password,
      admin_flag: flag
    )

 TeachingAssistant.create!(
   year: "0001",
   number: "00000000",
   name: "ダミー君",
   grade:"M1", 
   labo:"山内研究室",
   description:"ダミーデータやで"
 )

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#3.times do |n|
#	TeachingAssistant.create!(
#		year: 2023,
#		number: "50M2300#{n}",
#		name: "TA#{n}",
#		grade: "M1",
#		labo: "TEACHER#{n}" ,
#		description: "TEST#{n}"
#	)
#end
#
#3.times do |n|
#	Course.create!(
#		year: 2023,
#		term: "#{n}",
#		number: "09000#{n}",
#		name: "Course#{n}",
#		instructor: "Teacher#{n}",
#		time_budget: (n+1)*1000,
#		description: "TTTT#{n}",
#	)
#end

# Course1にTA1を割り当てる．
# Assignment.create{
# 	:course_id => TeachingAssistant.find(1).id,
# 	:teaching_assistant_id => TeachingAssistant.find(1).id,
# 	description: "TA:1 Course:1"
# }

# 3.times do |n|
# 	Course.create!(
# 		dtstart: DateTime.new(2023, 6, 5, 10, 0, 00)
# 		dtend: DateTime.new(2023, 6, 5, 11, 30, 00)
# 		actual_working_minutes: 60
# 		assignment_id: Assignment.find(1).id
# 	)
# end

# WorkHour.create!(
# 	dtstart: DateTime.new(2023, 6, 5, 10, 0, 00),
# 	dtend: DateTime.new(2023, 6, 5, 11, 30, 00),
# 	actual_working_minutes: 60,
# 	assignment_id: Assignment.find(1).id
# )

# WorkHour.create!(
# 	dtstart: DateTime.new(2023, 6, 5, 12, 0, 00),
# 	dtend: DateTime.new(2023, 6, 5, 15, 30, 00),
# 	actual_working_minutes: 80,
# 	assignment_id: Assignment.find(1).id
# )

# WorkHour.create!(
# 	dtstart: DateTime.new(2023, 6, 7, 10, 0, 00),
# 	dtend: DateTime.new(2023, 6, 7, 11, 30, 00),
# 	actual_working_minutes: 60,
# 	assignment_id: Assignment.find(1).id
# )
