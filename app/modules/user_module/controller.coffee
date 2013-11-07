homePage = (req, res) ->
	res.send('Home Page')
exports.homePage = homePage

loginPage = (req, res)->
	res.send('Login Page')
exports.loginPage = loginPage

registerPage = (req, res)->
	res.send('Register Page')
exports.registerPage = registerPage

logout = (req, res)->
	res.send('Logout Page')
exports.logout = logout

session = (req, res)->
	res.send('Dashboard Page')
exports.session = session

signin =  (req, res)->
	res.send('Signed In')
exports.signin = signin

authCallback = (req, res) ->
	console.log(req.user)
	res.send('Auth Callback')
exports.authCallback = authCallback

createUser = (req, res) ->
	res.send('Create User')
exports.createUser = createUser

showUser = (req, res) ->
	res.send('Show User')
exports.showUser = showUser

