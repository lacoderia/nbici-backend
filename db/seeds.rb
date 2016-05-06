# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users
user = User.create(first_name: "Arnulfo", last_name: "Quimare", email: "usuario_prueba@email.com", classes_left: 2, last_class_purchased: Time.now, picture: "url", uid: "XID3423423", password: "cantbeblank", phone: "55456792")

#Roles
role_instructor = Role.create(name: 'instructor')
role_super_admin = Role.create(name: 'super_admin')
role_front_desk = Role.create(name: 'front_desk')

#Instructors
instructor = Instructor.create(first_name: "Morenazo", last_name: "Nazo", picture: "url", bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", quote: "¡Yo soy tu maestro!")

admin_user_instructor = AdminUser.create!(email: 'morenazo@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor)

#Active Admin User
AdminUser.create!(email: 'admin@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_super_admin])

#Front desk
AdminUser.create!(email: 'info@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_front_desk])

#Emails
email = Email.create(user: user, email_status: "sent", email_type: "purchase")

#Packs
pack_1 = Pack.create(description: "1 clase", classes: 1, price: 140.00, special_price: 100.00, expiration: 15)
pack_2 = Pack.create(description: "5 clases", classes: 5, price: 650.00, expiration: 30)
pack_3 = Pack.create(description: "10 clases", classes: 10, price: 1200.00, expiration: 90)
pack_4 = Pack.create(description: "25 clases", classes: 25, price: 2875.00, expiration: 180)
pack_5 = Pack.create(description: "50 clases", classes: 50, price: 5000.00, expiration: 365)


#Purchases
puchase = Purchase.create(pack: pack_1, user: user, uid: "523dd8f6aef8784386000001", object:"charge", livemode: false, status: "paid", description: "Stogies", amount: 200, currency: "MXN", payment_method: "{'object':'card_payment', 'name':'Thomas Logan', 'exp_month':'12', 'exp_year':'15'}", details: "{'name':'Arnulfo Quimare', 'phone':'403-342-0642', 'email':'logan@x-men.org'}")

#Cards
card = Card.create(user: user, uid: "tok_test_visa_4242", object: 'card', name:'Thomas Logan', phone: '45321345', last4:'4242', exp_month:'12', exp_year:'17', active:true, address: "{'street1':'250 Alexis St', 'street2': null, 'street3': null, 'city':'Red Deer', 'state':'Alberta', 'zip':'T4N 0B8', 'country':'Canada'}", primary: true, brand: "VISA")

#Venues
venue = Venue.create(name: "Gimnasio SLP", description: "Gimnasio original")

#Bicycles
bicycle1 = Bicycle.new(position:1, number:1)
bicycle2 = Bicycle.new(position:13, number:2)
bicycle3 = Bicycle.new(position:25, number:3)
bicycle4 = Bicycle.new(position:37, number:4)
bicycle5 = Bicycle.new(position:39, number:5)
bicycle6 = Bicycle.new(position:29, number:6)
bicycle7 = Bicycle.new(position:19, number:7)
bicycle8 = Bicycle.new(position:20, number:8)
bicycle9 = Bicycle.new(position:10, number:9)
bicycle10 = Bicycle.new(position:34, number:10)
bicycle11 = Bicycle.new(position:46, number:11)
bicycle12 = Bicycle.new(position:58, number:12)
bicycle13 = Bicycle.new(position:70, number:13)
bicycle14 = Bicycle.new(position:61, number:14)
bicycle15 = Bicycle.new(position:62, number:15)
bicycle16 = Bicycle.new(position:52, number:16)
bicycle17 = Bicycle.new(position:42, number:17)
bicycle18 = Bicycle.new(position:67, number:18)
bicycle19 = Bicycle.new(position:79, number:19)

#Distributions
distribution = Distribution.create(height: 8, width: 11, description: "distribucion actual", inactive_seats: "", active_seats: Bicycle.to_string_array([bicycle1,bicycle2,bicycle3,bicycle4,bicycle5,bicycle6,bicycle7,bicycle8,bicycle9,bicycle10,bicycle11,bicycle12,bicycle13,bicycle14,bicycle15,bicycle16,bicycle17,bicycle18,bicycle19]), total_seats: 19)

#Room
room = Room.create(venue: venue, distribution: distribution, description: "Salón original")

#Schedules
schedule_1 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 6.hours + 1.days)
schedule_2 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 7.hours + 1.days)
schedule_3 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 8.hours + 1.days)
schedule_4 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 9.hours + 1.days)
schedule_5 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 1.days)
schedule_6 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 17.hours + 1.days)
schedule_7 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 18.hours + 1.days)
schedule_8 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 19.hours + 1.days)
schedule_9 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 20.hours + 1.days)

schedule_10 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 6.hours + 2.days)
schedule_11 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 7.hours + 2.days)
schedule_12 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 8.hours + 2.days)
schedule_13 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 9.hours + 2.days)
schedule_14 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 2.days)
schedule_15 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 17.hours + 2.days)
schedule_16 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 18.hours + 2.days)
schedule_17 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 19.hours + 2.days)
schedule_18 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 20.hours + 2.days)

schedule_20 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 6.hours + 3.days)
schedule_21 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 7.hours + 3.days)
schedule_22 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 8.hours + 3.days)
schedule_23 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 9.hours + 3.days)
schedule_24 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 3.days)
schedule_25 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 17.hours + 3.days)
schedule_26 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 18.hours + 3.days)
schedule_27 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 19.hours + 3.days)
schedule_28 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 20.hours + 3.days)

schedule_30 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 6.hours + 4.days)
schedule_31 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 7.hours + 4.days)
schedule_32 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 8.hours + 4.days)
schedule_33 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 9.hours + 4.days)
schedule_34 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 4.days)
schedule_35 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 17.hours + 4.days)
schedule_36 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 18.hours + 4.days)
schedule_37 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 19.hours + 4.days)
schedule_38 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 20.hours + 4.days)

schedule_40 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 5.days)
schedule_41 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 11.hours + 5.days)
schedule_42 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 12.hours + 5.days)

#Appointment
appointment = Appointment.create(user: user, schedule: schedule_1, bicycle_number: 1, status: 'BOOKED', start: schedule_1.datetime, description: "Con mi maestro favorito")
