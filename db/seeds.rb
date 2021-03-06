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
role_niumedia = Role.create(name: 'niumedia')
role_dafit = Role.create(name: "dafit")

#Dafit owner

dafit_owner = AdminUser.create!(email: 'damalvarado151289@gmail.com', password: 'dafit2020', password_confirmation: 'dafit2020', roles: [role_dafit])

#Instructors

#Ale
instructor_ale = Instructor.create(first_name: "Ale", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", bio: "", quote: "Train with style!")
AdminUser.create!(email: 'ale@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_ale)

instructor_samuel = Instructor.create(first_name: "Samuel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", bio: "", quote: "Pain is temporary, pride is forever.")
AdminUser.create!(email: 'samuel@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_samuel)

instructor_maca = Instructor.create(first_name: "Maca", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", bio: "", quote: "Por siempre se compone de ahoras.")
AdminUser.create!(email: 'maca@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_maca)

instructor_isa = Instructor.create(first_name: "Isa", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", bio: "", quote: "Deja que la música te haga volar!")
AdminUser.create!(email: 'isa@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_isa)

instructor_geor = Instructor.create(first_name: "Geor", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", bio: "", quote: "Sé siempre la mejor versión de ti mismo.")
AdminUser.create!(email: 'geor@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_geor)

instructor_miguel = Instructor.create(first_name: "Miguel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", bio: "", quote: "Sé el cambio que deseas ver en el mundo.")
AdminUser.create!(email: 'miguel@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_miguel)

instructor_marilu = Instructor.create(first_name: "Marilú", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", bio: "", quote: "Cambia tu cuerpo, tu mente, tu actitud y tu humor.")
AdminUser.create!(email: 'marilu@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_marilu)

instructor_diana = Instructor.create(first_name: "Diana", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", bio: "", quote: "Que todo fluya y que nada influya.")
AdminUser.create!(email: 'diana@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_diana)

instructor_sofi = Instructor.create(first_name: "Sofia V", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", bio: "", quote: "Mueve al ritmo de la música todo tu cuerpo.")
AdminUser.create!(email: 'sofi@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_sofi)

#Active Admin User
AdminUser.create!(email: 'admin@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_super_admin])

#Front desk
AdminUser.create!(email: 'info@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_front_desk])

#Niumedia
AdminUser.create!(email: 'admin@niumedia.mx', password: 'niumedia', password_confirmation: 'niumedia', roles: [role_niumedia])

#Emails
email = Email.create(user: user, email_status: "sent", email_type: "purchase")

#Packs
pack_1 = Pack.create(description: "1 clase", classes: 1, price: 140.00, special_price: 100.00, expiration: 15)
pack_2 = Pack.create(description: "5 clases", classes: 5, price: 650.00, expiration: 30)
pack_3 = Pack.create(description: "10 clases", classes: 10, price: 1200.00, expiration: 90)
pack_4 = Pack.create(description: "25 clases", classes: 25, price: 2875.00, expiration: 180)
pack_5 = Pack.create(description: "50 clases", classes: 50, price: 5000.00, expiration: 365)


#Purchases
#puchase = Purchase.create(pack: pack_1, user: user, uid: "523dd8f6aef8784386000001", object:"charge", livemode: false, status: "paid", description: "Stogies", amount: 200, currency: "MXN", payment_method: "{'object':'card_payment', 'name':'Thomas Logan', 'exp_month':'12', 'exp_year':'15'}", details: "{'name':'Arnulfo Quimare', 'phone':'403-342-0642', 'email':'logan@x-men.org'}")

#Cards
#card = Card.create(user: user, uid: "tok_test_visa_4242", object: 'card', name:'Thomas Logan', phone: '45321345', last4:'4242', exp_month:'12', exp_year:'17', active:true, address: "{'street1':'250 Alexis St', 'street2': null, 'street3': null, 'city':'Red Deer', 'state':'Alberta', 'zip':'T4N 0B8', 'country':'Canada'}", primary: true, brand: "VISA")

#Venues
venue = Venue.create(name: "Gimnasio SLP", description: "Gimnasio original")
venue_2 = Venue.create(name: "Gimnasio Aniversario", description: "Gimnasio aniversario")
venue_3 = Venue.create(name: "Gimnasio Distanciamiento", description: "Gimnasio para covid")
venue_4 = Venue.create(name: "Gimnasio Distanciamiento 2", description: "Gimnasio para covid")
venue_5 = Venue.create(name: "Aire Libre", description: "Aire libre")

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
bicycle20 = Bicycle.new(position:80, number:20)
bicycle21 = Bicycle.new(position:81, number:21)
bicycle22 = Bicycle.new(position:83, number:22)
bicycle23 = Bicycle.new(position:84, number:23)
bicycle24 = Bicycle.new(position:74, number:24)
bicycle25 = Bicycle.new(position:64, number:25)

new_bicycle1 = Bicycle.new(position:1, number:1)
new_bicycle2 = Bicycle.new(position:35, number:2)
new_bicycle3 = Bicycle.new(position:26, number:3)
new_bicycle4 = Bicycle.new(position:40, number:4)
new_bicycle5 = Bicycle.new(position:31, number:5)
new_bicycle6 = Bicycle.new(position:55, number:6)
new_bicycle7 = Bicycle.new(position:67, number:7)
new_bicycle8 = Bicycle.new(position:70, number:8)
new_bicycle9 = Bicycle.new(position:74, number:9)
new_bicycle10 = Bicycle.new(position:87, number:10)

cv1 = Bicycle.new(position:1, number:1)
cv2 = Bicycle.new(position:34, number:2)
cv3 = Bicycle.new(position:25, number:3)
cv4 = Bicycle.new(position:39, number:4)
cv5 = Bicycle.new(position:19, number:5)
cv6 = Bicycle.new(position:11, number:6)
cv7 = Bicycle.new(position:67, number:7)
cv8 = Bicycle.new(position:69, number:8)
cv9 = Bicycle.new(position:71, number:9)
cv10 = Bicycle.new(position:43, number:10)
cv11 = Bicycle.new(position:52, number:11)
cv12 = Bicycle.new(position:84, number:12)
cv13 = Bicycle.new(position:87, number:13)

cvv1 = Bicycle.new(position:3, number:1)
cvv2 = Bicycle.new(position:26, number:2)
cvv3 = Bicycle.new(position:38, number:3)
cvv4 = Bicycle.new(position:40, number:4)
cvv5 = Bicycle.new(position:30, number:5)
cvv6 = Bicycle.new(position:21, number:6)
cvv7 = Bicycle.new(position:11, number:7)
cvv8 = Bicycle.new(position:1, number:8)
cvv9 = Bicycle.new(position:24, number:9)
cvv10 = Bicycle.new(position:58, number:10)
cvv11 = Bicycle.new(position:72, number:11)
cvv12 = Bicycle.new(position:64, number:12)
cvv13 = Bicycle.new(position:43, number:13)
cvv14 = Bicycle.new(position:67, number:14)
cvv15 = Bicycle.new(position:80, number:15)
cvv16 = Bicycle.new(position:82, number:16)
cvv17 = Bicycle.new(position:84, number:17)

cvd1 = Bicycle.new(position:1, number:1)
cvd2 = Bicycle.new(position:16, number:3)
cvd3 = Bicycle.new(position:20, number:5)
cvd4 = Bicycle.new(position:47, number:2)
cvd5 = Bicycle.new(position:51, number:4)
cvd6 = Bicycle.new(position:55, number:6)
cvd7 = Bicycle.new(position:82, number:7)

sz1 = Bicycle.new(position:2, number:1)
sz2 = Bicycle.new(position:11, number:7)
sz3 = Bicycle.new(position:12, number:8)
sz4 = Bicycle.new(position:21, number:6)
sz5 = Bicycle.new(position:25, number:2)
sz6 = Bicycle.new(position:30, number:5)
sz7 = Bicycle.new(position:34, number:9)
sz8 = Bicycle.new(position:38, number:3)
sz9 = Bicycle.new(position:40, number:4)
sz10 = Bicycle.new(position:43, number:13)
sz11 = Bicycle.new(position:46, number:11)
sz12 = Bicycle.new(position:55, number:19)
sz13 = Bicycle.new(position:58, number:10)
sz14 = Bicycle.new(position:62, number:20)
sz15 = Bicycle.new(position:64, number:12)
sz16 = Bicycle.new(position:67, number:14)
sz17 = Bicycle.new(position:79, number:15)
sz18 = Bicycle.new(position:81, number:16)
sz19 = Bicycle.new(position:83, number:17)
sz20 = Bicycle.new(position:85, number:18)
sz21 = Bicycle.new(position:88, number:21)

zu1 = Bicycle.new(position:12, number:1)
zu2 = Bicycle.new(position:3, number:2)
zu3 = Bicycle.new(position:16, number:3)
zu4 = Bicycle.new(position:29, number:4)
zu5 = Bicycle.new(position:20, number:5)
zu6 = Bicycle.new(position:33, number:6)
zu7 = Bicycle.new(position:36, number:7)
zu8 = Bicycle.new(position:50, number:8)
zu9 = Bicycle.new(position:53, number:9)
zu10 = Bicycle.new(position:56, number:10)
zu11 = Bicycle.new(position:59, number:11)
zu12 = Bicycle.new(position:74, number:12)
zu13 = Bicycle.new(position:66, number:13)
zu14 = Bicycle.new(position:80, number:14)
zu15 = Bicycle.new(position:83, number:15)

zun1 = Bicycle.new(position:3, number:1)
zun2 = Bicycle.new(position:16, number:2)
zun3 = Bicycle.new(position:29, number:3)
zun4 = Bicycle.new(position:20, number:4)
zun5 = Bicycle.new(position:33, number:5)

#Distributions
distribution = Distribution.create(height: 8, width: 11, description: "distribucion actual", inactive_seats: "", active_seats: Bicycle.to_string_array([bicycle1,bicycle2,bicycle3,bicycle4,bicycle5,bicycle6,bicycle7,bicycle8,bicycle9,bicycle10,bicycle11,bicycle12,bicycle13,bicycle14,bicycle15,bicycle16,bicycle17,bicycle18,bicycle19]), total_seats: 19)

distribution_2 = Distribution.create(height: 9, width: 11, description: "distribucion aniversario", inactive_seats: "", active_seats: Bicycle.to_string_array([bicycle1,bicycle2,bicycle3,bicycle4,bicycle5,bicycle6,bicycle7,bicycle8,bicycle9,bicycle10,bicycle11,bicycle12,bicycle13,bicycle14,bicycle15,bicycle16,bicycle17,bicycle18,bicycle19,bicycle20,bicycle21,bicycle22,bicycle23,bicycle24,bicycle25]), total_seats: 25)

distribution_3 = Distribution.create(height: 8, width: 11, description: "distribucion covid", inactive_seats: "", active_seats: Bicycle.to_string_array([new_bicycle1, new_bicycle2, new_bicycle3, new_bicycle4, new_bicycle5, new_bicycle6, new_bicycle7, new_bicycle8, new_bicycle9, new_bicycle10]), total_seats: 10)

distribution_4 = Distribution.create(height: 8, width: 11, description: "distribucion covid 2", inactive_seats: "", active_seats: Bicycle.to_string_array([cv1, cv2, cv3, cv4, cv5, cv6, cv7, cv8, cv9, cv10, cv11, cv12, cv13]), total_seats: 13)

distribution_5 = Distribution.create(height: 8, width: 11, description: "distribucion covid 3", inactive_seats: "", active_seats: Bicycle.to_string_array([cvv1, cvv2, cvv3, cvv4, cvv5, cvv6, cvv7, cvv8, cvv9, cvv10, cvv11, cvv12, cvv13, cvv14, cvv15, cvv16, cvv17]), total_seats: 17)

distribution_6 = Distribution.create(height: 8, width: 11, description: "distribucion covid 4", inactive_seats: "", active_seats: Bicycle.to_string_array([cvd1, cvd2, cvd3, cvd4, cvd5, cvd6, cvd7]), total_seats: 7)

distribution_7 = Distribution.create(height: 8, width: 11, description: "distribucion aire libre", inactive_seats: "", active_seats: Bicycle.to_string_array([sz1,sz2,sz3,sz4,sz5,sz6,sz7,sz8,sz9,sz10,sz11,sz12,sz13,sz14,sz15,sz16,sz17,sz18,sz19,sz20,sz21]), total_seats: 21)

distribution_8 = Distribution.create(height: 8, width: 11, description: "distribucion zonauno 15", inactive_seats: "", active_seats: Bicycle.to_string_array([zu1,zu2,zu3,zu4,zu5,zu6,zu7,zu8,zu9,zu10,zu11,zu12,zu13,zu14,zu15]), total_seats: 15)

distribution_9 = Distribution.create(height: 8, width: 11, description: "distribucion estudio 15", inactive_seats: "", active_seats: Bicycle.to_string_array([zu1,zu2,zu3,zu4,zu5,zu6,zu7,zu8,zu9,zu10,zu11,zu12,zu13,zu14,zu15]), total_seats: 15)

distribution_10 = Distribution.create(height: 8, width: 11, description: "distribucion zonauno 5", inactive_seats: "", active_seats: Bicycle.to_string_array([zun1, zun2, zun3, zun4, zun5]), total_seats: 5)

#Room
room = Room.create(venue: venue, distribution: distribution, description: "Salón original")

room_2 = Room.create(venue: venue_2, distribution: distribution_2, description: "Salón aniversario")

room_3 = Room.create(venue: venue_3, distribution: distribution_3, description: "Salón distanciamiento")

room_4 = Room.create(venue: venue_3, distribution: distribution_4, description: "Salón distanciamiento 2")

room_5 = Room.create(venue: venue_4, distribution: distribution_5, description: "Salón distanciamiento 3")

room_6 = Room.create(venue: venue_4, distribution: distribution_6, description: "Salón distanciamiento 4")

room_7 = Room.create(venue: venue_5, distribution: distribution_7, description: "Zona uno")

room_8 = Room.create(venue: venue_5, distribution: distribution_8, description: "Zona uno 15")

room_9 = Room.create(venue: venue_4, distribution: distribution_9, description: "15 bicis")

room_10 = Room.create(venue: Venue.last, distribution: distribution_10, description: "5 bicis")

#Schedules

monday = Time.zone.now.beginning_of_day + 3.days
tuesday = monday + 1.day
wednesday = tuesday + 1.day
thursday = wednesday + 1.day
friday = thursday + 1.day
saturday = friday + 1.day

next_monday = monday + 7.days
next_tuesday = next_monday + 1.day
next_wednesday = next_tuesday + 1.day
next_thursday = next_wednesday + 1.day
next_friday = next_thursday + 1.day
next_saturday = next_friday + 1.day


#Monday
schedule_1 = Schedule.create(instructor: instructor_ale, room: room, datetime: monday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: monday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: monday + 8.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: monday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: monday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: monday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: monday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: monday + 20.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 21.hours)

#Tuesday
schedule_2 = Schedule.create(instructor: instructor_samuel, room: room, datetime: tuesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_ale, room: room, datetime: tuesday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: tuesday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: tuesday + 18.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: tuesday + 19.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: tuesday + 20.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 21.hours)

#Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: wednesday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: wednesday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: wednesday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: wednesday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: wednesday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: wednesday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: wednesday + 20.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: wednesday + 21.hours)

#Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 7.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: thursday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 17.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: thursday + 18.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: thursday + 19.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 20.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: thursday + 21.hours)

#Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: friday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_maca, room: room, datetime: friday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: friday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: friday + 19.hours)

#Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: saturday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: saturday + 11.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: saturday + 12.hours)

#Next Monday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_monday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_monday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_monday + 8.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_monday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_monday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_monday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_monday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_monday + 20.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 21.hours)

#Next Tuesday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_tuesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_tuesday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_tuesday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_tuesday + 18.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_tuesday + 19.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_tuesday + 20.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 21.hours)

#Next Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_wednesday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_wednesday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_wednesday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_wednesday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_wednesday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_wednesday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_wednesday + 20.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_wednesday + 21.hours)

#Next Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 7.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_thursday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 17.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_thursday + 18.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_thursday + 19.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 20.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_thursday + 21.hours)

#Next Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_friday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_friday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_friday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_friday + 19.hours)

#Next Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_saturday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_saturday + 11.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_saturday + 12.hours)

#Appointment
appointment = Appointment.create(user: user, schedule: schedule_1, bicycle_number: 1, status: 'BOOKED', start: schedule_1.datetime, description: "Con mi maestro favorito")
appointment_2 = Appointment.create(user: user, schedule: schedule_2, bicycle_number: 1, status: 'BOOKED', start: schedule_2.datetime, description: "Con mi maestro favorito")

#Configuration
Configuration.create(key: "coupon_discount", value: "40")
Configuration.create(key: "referral_credit", value: "40")
Configuration.create(key: "free_classes_start_date", value: (Time.zone.now + 1.month).strftime("%FT%T.%L%:z") )
Configuration.create(key: "free_classes_end_date", value: (Time.zone.now + 2.month).strftime("%FT%T.%L%:z") )
Configuration.create(key: "dafit_closed_start_date", value: (Time.zone.now - 2.month).strftime("%FT%T.%L%:z") )
Configuration.create(key: "dafit_closed_end_date", value: (Time.zone.now + 1.hour - 2.month).strftime("%FT%T.%L%:z") )
Configuration.create(key: "dafit_email", value: "damalvarado151289@gmail.com" )
Configuration.create(key: "playable_hours", value: "24" )


#MenuCategories
cat_smoothies = MenuCategory.create(name:"SMOOTHIES", image_url: "https://n-bici.com/wp-content/uploads/2020/02/SMOOTHIES.jpg")
cat_sandwiches = MenuCategory.create(name:"SANDWICHES", image_url: "https://n-bici.com/wp-content/uploads/2020/02/SANDWICHES.jpg")
cat_juices = MenuCategory.create(name:"JUICES", image_url: "https://n-bici.com/wp-content/uploads/2020/02/JUGOS.jpg")
cat_snacks = MenuCategory.create(name:"ENERGY SNACKS", image_url: "https://n-bici.com/wp-content/uploads/2020/02/ENERGY-SNACKS.jpg")
cat_toast = MenuCategory.create(name:"ENERGY TOAST", image_url: "https://n-bici.com/wp-content/uploads/2020/02/ENERGY-TOAST.jpg")

#MenuItems
#Smoothies
MenuItem.create(name: "TROPICAL GREEN", description: "espinaca, mango, piña, leche de almandra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "DARK CHOCO-PEANUT", description: "plátano, crema de cacahuate, cocoa, leche de almendra, proteína de chocolate", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "RED BANANA", description: "plátano, fresa, yogurt griego, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "RECOVERY CHIA", description: "espinaca, chia, crema de cacahuate, avena, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "BASIC BERRIES", description: "berries, fresas, yogurt griego, leche de almendra, proteína de vainilla, nuez", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "REFRESH YOURSELF", description: "melón, pepino, menta, leche de almendra,proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "BERRY GOOD", description: "berries, fresas, plátano, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "BEAUTY BREW", description: "café helado, colágeno, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "DAFIT PEELED", description: "plátano, crema de cacahuate, jarabe de agave, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "SHAKE IT", description: "berries, crema de cacahuate, jarabe de agave, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "MANGO RAVE", description: "mango, nuez, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "TAKE OUT", description: "papaya, mango, nuez, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "VANILLA LOVER", description: "extracto de vainilla, plátano, avena, leche de almendra, proteína de vainilla", price: 75.0, active: true, menu_category: cat_smoothies)
MenuItem.create(name: "MAKE YOUR OWN", description: "escoge 3 ingredientes y crea tu smoothie", price: 75.0, active: true, menu_category: cat_smoothies)
#Sandwiches
MenuItem.create(name: "PRESSED TURKEY", description: "pechuga de pavo, pan integral, verduras salteadas, queso panela o gouda, aguacate", price: 60.0, active: true, menu_category: cat_sandwiches)
MenuItem.create(name: "VEGAN SANDWICH", description: "verduras salteadas, aguacate, queso panela, pan integral", price: 60.0, active: true, menu_category: cat_sandwiches)
MenuItem.create(name: "VEGETARIAN SANDWICH", description: "berenjena, calabaza, queso gouda, pan integral, jitomate, cebolla, lechuga, aderezo de nuez, albahaca", price: 60.0, active: true, menu_category: cat_sandwiches)
MenuItem.create(name: "SIMPLE SANDWICH", description: "pan integral, queso panela, pechuga de pavo, espinaca, aderezo de chipotle", price: 60.0, active: true, menu_category: cat_sandwiches)
MenuItem.create(name: "ITALIAN SANDWICH", description: "pechuga de pavo, pepperoni, queso gouda, lechuga, aderezo italiano, aguacate", price: 60.0, active: true, menu_category: cat_sandwiches)
#JUICES
MenuItem.create(name: "SPECIAL GREEN JUICE", description: "pepino, apio, perejil, menta, kale, espinaca, kiwi, papaya, mango, piña, jugo de naranja", price: 45.0, active: true, menu_category: cat_juices)
MenuItem.create(name: "DETOX", description: "kale, espinaca, perejil, piña, hielo", price: 35.0, active: true, menu_category: cat_juices)
MenuItem.create(name: "BEFORE WORKOUT", description: "albahaca, zanahoria, betabel, limón, pepino", price: 35.0, active: true, menu_category: cat_juices)
MenuItem.create(name: "AFTER WORKOUT", description: "betabel, apio, pepino, manzana verde, piña espinaca", price: 35.0, active: true, menu_category: cat_juices)
MenuItem.create(name: "TONING", description: "manzana verde, piña, espinaca", price: 35.0, active: true, menu_category: cat_juices)
MenuItem.create(name: "BURN FAT", description: "pepino, espinaca, acelga y limón", price: 35.0, active: true, menu_category: cat_juices)
#ENERGY SNACKS
MenuItem.create(name: "ENERGY BITES", description: "crema de cacahuate, avena, miel, chispas de chocolate", price: 10.0, active: true, menu_category: cat_snacks)
MenuItem.create(name: "HOMEMADE PROTEIN BAR", description: "crema de cacahuate, avena, proteina, chocolate, miel", price: 25.0, active: true, menu_category: cat_snacks)
MenuItem.create(name: "COOKIES", description: "galletas de avena, miel", price: 10.0, active: true, menu_category: cat_snacks)
#ENERGY TOAST
MenuItem.create(name: "SWEET OPTION", description: "crema de cacahuate y/o nutella, chia, miel", price: 35.0, active: true, menu_category: cat_toast)
MenuItem.create(name: "THE BEST", description: "nutella y/o queso crema, fresa, nuez", price: 40.0, active: true, menu_category: cat_toast)
MenuItem.create(name: "CLASSIC", description: "nutella y/o crema de cacahuate, plátano", price: 35.0, active: true, menu_category: cat_toast)
