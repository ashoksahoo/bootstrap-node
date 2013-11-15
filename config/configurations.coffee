path = require('path')
extend = require('extend')
breadCrumbs = require('./breadCrumbMap')
userRoles = require('../lib/userRoles')
MailingService = require('../lib/mailingService').MailingService
nodemailer = require('nodemailer')

getPageInfo = (req, templateName, pageHeader, subHeader)->
	pageInfo = {
		header: pageHeader
		subHeader: subHeader
	}
	if(req.session && req.session.user)
		pageInfo.userLoggedIn = true
		pageInfo.isFreeAccount =  userRoles.isFreeAccount(req.session.user.role)

	extend(true, pageInfo, breadCrumbs.getBreadCrumbs(templateName))

getEnvironemnt = () ->
	switch process.env.NODE_ENV
		when 'production' then 'production'
		when 'test' then 'test'
		else 'development'

constructXhrCallback = (req, res, onSuccess)->
	return (data, hasError, code)->
		response =
			code : 0
		if hasError
			response.message = data
			response.code = code if code
		else
			response.data = data
			if onSuccess
				onSuccess(req, data, response)

		res.send(response)

configureMailer = (config)->
	if not config.mailer or not config.mailer.smtpSettings
		return;

	smtpOptions = config.mailer.smtpSettings;

	mailingService = Object.create(MailingService);
	mailingService.mailer = nodemailer.createTransport("SMTP", smtpOptions);
	mailingService.fromMail = config.mailer.from;

	config.mailingService = mailingService

getConfigs = (environmentConfig)->
	appRootPath = path.join(__dirname, '..');
	modulePath = path.join(appRootPath, 'app/modules');
	stylesPath = path.join(appRootPath, 'public/styles/');
	staticPath = path.join(appRootPath, 'public');

	config = {
		stylesPath: stylesPath,
		staticPath: staticPath,
		modulePath: modulePath,
		cookieSecret: 'bootstrap@1729@secret',
		rootPath: appRootPath,
		logger:
			info: (message) ->
				console.log message

			debug: (message)->
				console.log(message)

			error: (message, code) ->
				console.log(message)
				console.log(code)
		constructXhrCallback :constructXhrCallback
		getViewPaths: () ->
			fs = require('fs');
			filesArray = fs.readdirSync(modulePath);

			reg = new RegExp("\\w+_module");
			moduleNameArray = [];
			filesArray.filter (item) ->
				moduleNameArray.push path.join(modulePath, item, 'views') if (item.match(reg))

			moduleNameArray

		getPageInfo: getPageInfo
		constructCallback: (req, res, params)->
			(data, hasError, code)->
				response = {};
				if hasError
					response.message = data;
					response.code = code ? code: 0;
				else
					response.code = 1;
					response.data = data;


				if req.xhr
					res.send(response);
				else
					res.render params.template,
						data: data,
						pageInfo: getPageInfo req params.header
	}
	extend(true, environmentConfig, config)


module.exports = () ->
	if !configInstance
		environmentConfig = require('./environments/' + getEnvironemnt())
		configInstance = getConfigs environmentConfig;
		configureMailer configInstance
	configInstance
