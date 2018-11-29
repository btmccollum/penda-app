# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(username: "doodle", email: "test@test.com", first_name: "dudley", last_name: "brown", password: "123456", password_confirmation: "123456", type: "Client")
User.create(username: "testbiz", email: "testllc@test.com", first_name: "Jane", last_name: "Doe", password: "111111", password_confirmation: "111111", type: "Business")
new_project = Project.create(title: "Test Project 2", client_id: 1, business_id: 2)