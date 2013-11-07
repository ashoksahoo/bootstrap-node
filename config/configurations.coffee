path = require('path')
extend = require('extend')

getPageInfo = (req, pageHeader)->
	getBreadCrumbs = (path) ->	[	{name: 'Home', href: '/Dashboard', path: path}	];
#	schoolUrl = req.headers.host + (configs.subDomainEnabled ? '': '/schools/' + req.params.id);

	schoolName: req.params.id,
	breadCrumbs: getBreadCrumbs(req.url),
	pageHeader: pageHeader

getEnvironemnt = () ->
	switch process.env.NODE_ENV
		when 'production' then 'production'
		when 'test' then 'test'
		else
			'development'

getConfigs = (environmentConfig)->
	appRootPath = path.join(__dirname, '..');
	modulePath = path.join(appRootPath, 'app/modules');
	stylesPath = path.join(appRootPath, 'public/styles/');
	staticPath = path.join(appRootPath, 'public');

	config = {
		stylesPath: stylesPath,
		staticPath: staticPath,
		modulePath: modulePath,
		cookieSecret: 'quickpay@1729@secret',
		rootPath: appRootPath,
		logger:
			info: (message) ->
				console.log message

			debug: (message)->
				console.log(message)

			error: (message, code) ->
				console.log(message)
				console.log(code)

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
	environmentConfig = require('./environments/' + getEnvironemnt())
	getConfigs environmentConfig;
