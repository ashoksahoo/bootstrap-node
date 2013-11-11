path = require("path")
templatePath = path.normalize(__dirname + "/../app/mailer/templates")

module.exports =
	db: "mongodb://localhost/quickpay-dev"
	port: 3010
	app:
		name: "Bootstrap Node"
	notifier:
		service: "postmark"
		APN: false
		email: false # true
		actions: ["comment"]
		tplPath: templatePath
		key: "POSTMARK_KEY"
		parseAppId: "PARSE_APP_ID"
		parseApiKey: "PARSE_MASTER_KEY"
	facebook:
		clientID: "APP_ID",
		clientSecret: "APP_SECRET",
		callbackURL: "http://localhost:3000/auth/facebook/callback"
	twitter:
		clientID: "CONSUMER_KEY",
		clientSecret: "CONSUMER_SECRET",
		callbackURL: "http://localhost:3000/auth/twitter/callback"

	github:
		clientID: 'APP_ID',
		clientSecret: 'APP_SECRET',
		callbackURL: 'http://localhost:3000/auth/github/callback'

	google:
		clientID: "APP_ID",
		clientSecret: "APP_SECRET",
		callbackURL: "http://localhost:3000/auth/google/callback"

	linkedin:
		clientID: "CONSUMER_KEY",
		clientSecret: "CONSUMER_SECRET",
		callbackURL: "http://localhost:3000/auth/linkedin/callback"
		
