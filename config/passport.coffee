mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
TwitterStrategy = require("passport-twitter").Strategy
FacebookStrategy = require("passport-facebook").Strategy
GitHubStrategy = require("passport-github").Strategy
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
LinkedinStrategy = require("passport-linkedin").Strategy
User = mongoose.model("User")

module.exports = (passport, config) ->
	# require('./initializer')

	# serialize sessions
	passport.serializeUser (user, done) ->
		done null, user.id

	passport.deserializeUser (id, done) ->
		User.findOne {_id: id}, (err, user) ->
			done err, user


	# use local strategy
	passport.use new LocalStrategy(
		usernameField: "email"
		passwordField: "password"
	, (email, password, done) ->
		User.findOne
			email: email
		, (err, user) ->
			return done(err)  if err
			unless user
				done(null, false, message: "Unknown user")
			unless user.authenticate(password)
				done(null, false, message: "Invalid password")
			done null, user

	)

	# use twitter strategy
	passport.use new TwitterStrategy(
		consumerKey: config.twitter.clientID
		consumerSecret: config.twitter.clientSecret
		callbackURL: config.twitter.callbackURL
	, (token, tokenSecret, profile, done) ->
		User.findOne
			"twitter.id": profile.id
		, (err, user) ->
			return done(err)  if err
			unless user
				user = new User(
					name: profile.displayName
					username: profile.username
					provider: "twitter"
					twitter: profile._json
				)
				user.twitter.accessToken = token
				user.twitter.tokenSecret = tokenSecret
				user.save (err) ->
					console.log err  if err
					done err, user

			else
				done err, user

	)

	# use facebook strategy
	passport.use new FacebookStrategy(
		clientID: config.facebook.clientID
		clientSecret: config.facebook.clientSecret
		callbackURL: config.facebook.callbackURL
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"facebook.id": profile.id
		, (err, user) ->
			return done(err)  if err
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.username
					provider: "facebook"
					facebook: profile._json
				)
				user.facebook.accessToken = accessToken
				user.facebook.refreshToken = refreshToken
				user.save (err) ->
					console.log err  if err
					done err, user

			else
				done err, user

	)

	# use github strategy
	passport.use new GitHubStrategy(
		clientID: config.github.clientID
		clientSecret: config.github.clientSecret
		callbackURL: config.github.callbackURL
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"github.id": profile.id
		, (err, user) ->
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.username
					provider: "github"
					github: profile._json
				)
				user.github.accessToken = accessToken
				user.github.refreshToken = refreshToken
				user.save (err) ->
					console.log err  if err
					done err, user

			else
				done err, user
	)

	# use google strategy
	passport.use new GoogleStrategy(
		clientID: config.google.clientID
		clientSecret: config.google.clientSecret
		callbackURL: config.google.callbackURL
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"google.id": profile.id
		, (err, user) ->
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.username
					provider: "google"
					google: profile._json
				)
				user.google.accessToken = accessToken
				user.google.refreshToken = refreshToken
				user.save (err) ->
					console.log err  if err
					done err, user

			else
				done err, user

	)

	# use linkedin strategy
	passport.use new LinkedinStrategy(
		consumerKey: config.linkedin.clientID
		consumerSecret: config.linkedin.clientSecret
		callbackURL: config.linkedin.callbackURL
		profileFields: ["id", "first-name", "last-name", "email-address"]
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"linkedin.id": profile.id
		, (err, user) ->
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.emails[0].value
					provider: "linkedin"
					linkedin : profile._json
				)
				user.linkedin.accessToken = accessToken
				user.linkedin.refreshToken = refreshToken
				user.save (err) ->
					console.log err  if err
					done err, user

			else
				done err, user

	)