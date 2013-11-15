#User invitation details

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.ObjectId;
dataTypes = require('./dataTypes');

STRING = dataTypes.STRING
NUMBER = dataTypes.NUMBER

InvitationSchema = new Schema(
	by:
		id: ObjectId
		name: STRING
	status: NUMBER #-1 deleted, 0 not used, 1 used, 2 opened
	email: STRING
	created: Date
	deleted: Date
	opened: [
		date: Date
		ip: STRING
	]
)

mongoose.model('Invitation', InvitationSchema)