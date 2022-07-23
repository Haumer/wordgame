user = User.create(password: ENV['ADMIN_PW'], email: 'alexander.haumer@me.com', admin: true)
Game.create(name: 'Test')
