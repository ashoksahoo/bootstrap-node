mongoose = require("mongoose")
Schema = mongoose.Schema
crypto = require("crypto")
_ = require("underscore")
authTypes = ["github", "twitter", "facebook", "google", "linkedin"]
roles = ['user', 'premium', 'affiliate']
dataTypes = require('./dataTypes');

STRING = dataTypes.STRING

###
User Schema
###
UserSchema = new Schema(
	name: STRING
	email: STRING
	username: STRING
	provider: STRING
	hashed_password: STRING
	salt: STRING
	authToken: STRING
	role: STRING
	facebook: {}
	twitter: {}
	google: {}
	linkedin: {}
)

UserSchema.virtual("password").set((password) ->
	@_password = password
	@salt = @makeSalt()
	@hashed_password = @encryptPassword(password)
).get ->
	@_password


###
  UserSchema methods
###
UserSchema.methods =

	###
	  Authenticate - check if the passwords are the same
	  @param {String} plainText    @return {Boolean}  @api public
	###
	authenticate: (plainText) ->
		@encryptPassword(plainText) is @hashed_password

	###
	  Make salt
	  @return {String}   @api public
	###
	makeSalt: ->
		Math.round((new Date().valueOf() * Math.random())) + ""

	###
	  Encrypt password
	  @param {String} password   @return {String}  @api public
	###
	encryptPassword: (password) ->
		return ""  unless password
		encrypred = undefined
		try
			crypto.createHmac("sha1", @salt).update(password).digest("hex")
			encrypred
		catch err
		""

mongoose.model("User", UserSchema)