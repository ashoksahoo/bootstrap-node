nodemailer = require('nodemailer')


emailTypes =
	activation: 'a'
	invitation: 'i'

getBody = (type, params)->
	switch type
		when emailTypes.invitation then "Hi #{ params.toName } <br>Invitation link - #{ params.link } <br> #{ params.fromName }"
		when emailTypes.activation then "Hi #{ params.toName } <br>Activation link - #{ params.link }"
		else "Hi #{ params.toName } <br>"

#Getting the subjects basing on the type of email
getSubject = (type, otherName) ->
	switch type
		when emailTypes.invitation then 'An invitation by ' + otherName + ' to check Quick Pay'
		when emailTypes.activation then 'Activate your Quick Pay account'
		else
			'A mail from Quick Pay'

MailingService = {
	#Constructing the contents of the mail
	constructOptions : (to, subject, text)->
		from: @fromMail
		to: to
		subject: subject
		text: text

	#Function for sending the activation mail
	sendActivationMail : (name, email, activationLink) ->
		to = name + '<' + email + '>'
		text = getBody(emailTypes.invitation, {toName: name, link: activationLink})
		subject = getSubject emailTypes.invitation

		options = @constructOptions(to, subject, text)

		@mailer.sendMail(options, (error, response)->
			if error
				console.log(error)
			else
				console.log("Message sent: " + response.message)

		)


	#Function for sending the invitations mail
	sendInvitationMail : (name, email, invitor, inviteLink) ->
		to = name + '<' + email + '>'
		text = getBody(emailTypes.invitation, {toName : name, link : inviteLink, fromName: invitor.name})
		subject = getSubject emailTypes.invitation, invitor.name

		options = @constructOptions(to, subject, text)

		@mailer.sendMail(options, (error, response)->
			if error
				console.log(error)
			else
				console.log("Message sent: " + response.message)
		)
}

exports.MailingService = MailingService