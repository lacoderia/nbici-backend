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
user = User.create(first_name: "Arnulfo", last_name: "Quimare", email: "usuario_prueba@email.com", classes_left: 2, last_class_purchased: Time.now, picture: "url", uid: "XID3423423", roles: [role_user])

#Emails
email = Email.create(user: user, email_status: "sent", email_type: "purchase")

#Packs
pack_1 = Pack.create(description: "1 clase", classes: 1, price: 300.00, special_price: 200.00)
pack_2 = Pack.create(description: "5 clases", classes: 5, price: 1450.00)
pack_3 = Pack.create(description: "10 clases", classes: 10, price: 2800.00)
pack_4 = Pack.create(description: "25 clases", classes: 25, price: 6250.00)
pack_5 = Pack.create(description: "50 clases", classes: 50, price: 10000.00)


#Purchases
puchase = Purchase.create(pack: pack_1, user: user, uid: "523dd8f6aef8784386000001", object:"charge", livemode: false, status: "paid", description: "Stogies", amount: 200, currency: "MXN", payment_method: "{'object':'card_payment', 'name':'Thomas Logan', 'exp_month':'12', 'exp_year':'15'}", details: "{'name':'Arnulfo Quimare', 'phone':'403-342-0642', 'email':'logan@x-men.org'}")

#Cards
card = Card.create(user: user, uid: "card_9kWcdlL7xbvQu5jd3", object: 'card', name:'Thomas Logan', last4:'4242', exp_month:'12', exp_year:'17', active:true, address: "{'street1':'250 Alexis St', 'street2': null, 'street3': null, 'city':'Red Deer', 'state':'Alberta', 'zip':'T4N 0B8', 'country':'Canada'}")

#Instructors
instructor = Instructor.create(first_name: "Morenazo", last_name: "Nazo", email: "morenazo@nazo.com", picture: "url")

#Venues
venue = Venue.create(name: "Gimnasio SLP", description: "Gimnasio original")

#Distributions
distribution = Distribution.create(height: 5, width: 5, description: "cuadrado perfecto", inactive_seats: "{2,3,4,7,8,9}", active_seats: "{1,5,6,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}", total_seats: 19)

#Room
room = Room.create(venue: venue, distribution: distribution, description: "Salón original")

#Schedules
schedule = Schedule.create(instructor: instructor, room: room, datetime: Time.now)
