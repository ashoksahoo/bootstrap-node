config = require('../../../config/configurations')()
manager = require('./manager')
homePage = (req, res) ->
	#renders template 'homePage'
	res.render('homePage')
exports.homePage = homePage

loginPage = (req, res)->
	templateName = 'loginPage'
	pageInfo = config.getPageInfo(req, templateName, 'Login to Bootstrap-node', '')
	data = {pageInfo: pageInfo, hasMenu : false}
	res.render(templateName, data)

exports.loginPage = loginPage

#User dashboard
dashboardPage = (req, res, next)->
	templateName = 'dashboard'
	pageInfo = config.getPageInfo(req, templateName, 'Dashboard', '')

	#TODO: Put the account type in session. if type is free just place a variable in the below data

	data = {pageInfo: pageInfo, hasMenu : true}
	res.render(templateName, data)

exports.dashboardPage = dashboardPage

#New User Registration Page
signupPage = (req, res, next)->
	templateName = 'registerPage'
	pageInfo = config.getPageInfo(req, templateName, 'Register for Quick Pay', '')
	data = {pageInfo: pageInfo, hasMenu : false}
	res.render(templateName, data)

exports.signupPage = signupPage

signupUser = (req, res, next)->
	user =
		name:req.param('name')
		email:req.param('email')
		mobile:req.param('mobile')
		password : req.param('password')

	callback = (data, hasError, errorCode)->
		response =
			code : 0
		if hasError
			response.message = data
		else
			response =
			#Redirecting him to login will ensure the login from user the same.
			#As I am using Passport there is no point of creating a new flow for setting the cookies
			#TODO: I can log him in from server by making a request to passport
				data : '/login?msg="Account is created. Please log in to continue"'
				code : 1

		res.send response

	manager.createUser(user, callback)
exports.signupUser = signupUser

logout = (req, res)->
	res.send('Logout Page')
exports.logout = logout

inviteFriendsPage = (req, res, next) ->
	templateName = 'invitePage'
	pageInfo = config.getPageInfo(req, templateName, 'Refer your friends to earn credits', '')
	data = {pageInfo: pageInfo, hasMenu : false}
	res.render(templateName, data)

exports.inviteFriendsPage = inviteFriendsPage

inviteFriends = (req, res, next)->
	callback = config.constructXhrCallback(req, res)
	user = req.session.user
	emails = req.param('emails').split(',')
	manager.sendInvitations(user, emails, callback)

exports.inviteFriends = inviteFriends

openInvitation = (req, res, next)->


exports.openInvitation = openInvitation