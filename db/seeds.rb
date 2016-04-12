# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Roles
role_user = Role.create(name: 'user')

#Users
user = User.create(first_name: "Arnulfo", last_name: "Quimare", email: "usuario_prueba@email.com", classes_left: 2, last_class_purchased: Time.now, picture: "url", uid: "XID3423423", roles: [role_user], password: "cantbeblank", phone: "55456792")

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
card = Card.create(user: user, uid: "tok_test_visa_4242", object: 'card', name:'Thomas Logan', phone: '45321345', last4:'4242', exp_month:'12', exp_year:'17', active:true, address: "{'street1':'250 Alexis St', 'street2': null, 'street3': null, 'city':'Red Deer', 'state':'Alberta', 'zip':'T4N 0B8', 'country':'Canada'}")

#Instructors
instructor = Instructor.create(first_name: "Morenazo", last_name: "Nazo", email: "morenazo@nazo.com", picture: "url", bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", quote: "¡Yo soy tu maestro!")

#Venues
venue = Venue.create(name: "Gimnasio SLP", description: "Gimnasio original")

#Distributions
distribution = Distribution.create(height: 6, width: 10, description: "distribucion actual", inactive_seats: "[2,3,4,5,6,7,8,9,13,14,15,16,17,18,20,24,25,26,27,30,31,35,36,39,40,41,42,46,48,49,50,51,52,53,54,56,57,58,59,60]", active_seats: "[1,10,11,12,19,21,22,23,28,29,32,33,34,37,38,43,44,45,47,55]", total_seats: 20)

#Room
room = Room.create(venue: venue, distribution: distribution, description: "Salón original")

#Schedules
schedule_1 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 3.days)
schedule_2 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 11.hours + 3.days)
schedule_3 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 12.hours + 3.days)

schedule_4 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 10.hours + 4.days)
schedule_5 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 11.hours + 5.days)
schedule_6 = Schedule.create(instructor: instructor, room: room, datetime: Time.zone.now.beginning_of_day + 12.hours + 6.days)

#Appointment
appointment = Appointment.create(user: user, schedule: schedule_1, bicycle_number: 10, status: 'BOOKED', start: Time.zone.now.beginning_of_day + 10.hours + 3.days, description: "Con mi maestro favorito")
