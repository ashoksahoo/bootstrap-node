mongoose = require("mongoose")
Schema = mongoose.Schema
crypto = require("crypto")
authTypes = ["github", "twitter", "facebook", "google", "linkedin"]
roles = require('../../lib/userRoles')
dataTypes = require('./dataTypes');

STRING = dataTypes.STRING
NUMBER = dataTypes.NUMBER

UserSchema = new Schema(
	name: STRING
	email: STRING
	username: STRING
	mobile : NUMBER
	provider: STRING
	hashed_password: STRING
	salt: STRING
	authToken: STRING
	role: STRING
	facebook: {}
	twitter: {}
	google: {}
	linkedin: {}
	subscription:{}
)

UserSchema.virtual("hasFreeAccount").get ->
	@role == roles.Free || @role == ''

UserSchema.virtual("hasPremiumAccount").get ->
	@role == roles.Premium

UserSchema.virtual("password").set((password) ->
	@_password = password
	@salt = @makeSalt()
	@hashed_password = @encryptPassword(password)
).get ->
	@_password


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
			encrypred = crypto.createHmac("sha1", @salt).update(password).digest("hex")
			encrypred

		catch err
			""
	givePremiumAccess: ()->
		@role = roles.Premium

validatePresenceOf = (value)->
	value && value.length


###
Pre-save hook
###
UserSchema.pre "save", (next) ->

	return next()  unless @isNew
	if not validatePresenceOf(@role)
		@role = roles.Free
	if not validatePresenceOf(@password) and authTypes.indexOf(@provider) is -1
		next new Error("Invalid password")
	else
		next()

mongoose.model("User", UserSchema)