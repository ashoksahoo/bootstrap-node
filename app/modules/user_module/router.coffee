processAuthResponse = (req, res, err, user, info)->
	if err or not user
		if info
			info = encodeURIComponent(info);
		else
			info = 'Something wrong happened during the social login'
		res.redirect('/login?err='+info)
	else
		req.session.user =
			id: user.id
			role : user.role
			name : user.name
		res.redirect('/dashboard')



module.exports = (app, passport) ->
	path = require('path')
	users = require('./controller')
	isLoggedInUser = require('../../../config/role_moderator').isLoggedInUser;

	app.get('/', isLoggedInUser, users.homePage)
	app.get('/logout', isLoggedInUser, users.logout)
	app.get('/dashboard', isLoggedInUser, users.dashboardPage)

	app.get('/login', users.loginPage)
	app.get('/signup', users.signupPage)
	app.post('/signup', users.signupUser)

	app.get('/invite-friends', users.inviteFriendsPage)
	app.post('/invite-friends', users.inviteFriends)
	app.get('/invitations/id', users.openInvitation)

	app.post('/login', (req, res, next)->
		passport.authenticate('local', (err, user, info)->
			processAuthResponse(req, res, err, user, info)
		)(req, res, next)
	);

	app.get('/auth/facebook', passport.authenticate('facebook', {
		scope: [ 'email', 'user_about_me'],
		failureRedirect: '/login'
	}))

	app.get('/auth/facebook/callback', (req, res, next) ->
		passport.authenticate('facebook', (err, user, info)->
			processAuthResponse(req, res, err, user, info)
		)(req, res, next)
	)


	app.get('/auth/twitter',
		passport.authenticate('twitter', {
			failureRedirect: '/login'
		}))
	app.get('/auth/twitter/callback', (req, res, next)->
		passport.authenticate('twitter', (err, user, info)->
			processAuthResponse(req, res, err, user, info)
		)(req, res, next)
	)

	app.get('/auth/google',
		passport.authenticate('google', {
			failureRedirect: '/login',
			scope: [
				'https://www.googleapis.com/auth/userinfo.profile',
				'https://www.googleapis.com/auth/userinfo.email'
			]
		}))
	app.get('/auth/google/callback',(req, res, next)->
		passport.authenticate('google', (err, user, info)->
			processAuthResponse(req, res, err, user, info)
		)(req, res, next)
	)


	app.get('/auth/linkedin',
		passport.authenticate('linkedin', {
			failureRedirect: '/login',
			scope: [
				'r_emailaddress'
			]
		}))
	app.get('/auth/linkedin/callback',(req, res, next)->
		passport.authenticate('linkedin', (err, user, info)->
			processAuthResponse(req, res, err, user, info)
		)(req, res, next)
	)
