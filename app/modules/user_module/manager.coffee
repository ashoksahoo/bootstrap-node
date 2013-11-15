mongoose = require('mongoose')
path = require('path')
User = mongoose.model('User')
Invitation = mongoose.model('Invitation')
config = require('../../../config/configurations')()

createUser = (user, callback)->
	User.findOne({$or: [{email: user.email}, {mobile: user.mobile}]}, (err, obj)->
		if err
			callback 'Error while fetching User from email or mobile', true
		else if obj
			callback 'User already exists', true
		else
			User.create user, (err, obj)->
				callback obj

	)
exports.createUser = createUser

