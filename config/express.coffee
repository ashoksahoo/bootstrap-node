path = require('path')

enableMultipleViewFolders = (config) ->
	#Monkey-patch express to accept multiple paths for looking up views.
	#this path may change depending on your setup.

	View = require(path.join(config.rootPath, "/node_modules/express/lib/view"))
	lookup_proxy = View.prototype.lookup;

	View.prototype.lookup = (viewName) ->
		context = {}
		match = {}
		if this.root instanceof Array
			for mod in this.root
				context = {root: mod}
				match = lookup_proxy.call(context, viewName);
				if (match != undefined)
					return match

			return null;

		lookup_proxy.call this, viewName



module.exports =  (app, config) ->
	express = require('express')
	lessC = require("less-middleware")
	passport = require('passport')
	mongoStore = require('connect-mongo')(express)

	enableMultipleViewFolders config;
	app.set('views', config.getViewPaths())

	# all environments
	app.set('port', process.env.PORT || config.port)
	app.set('view engine', 'jade');
	app.use(express.favicon());
	app.use(express.logger('dev'));
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(express.cookieParser(config.cookieSecret))
	app.use(passport.initialize());
	app.use(passport.session());
	app.use(express.session({
		secret:'boostrap-node is awesome'
		store: new mongoStore({
			url: config.db,
			collection : 'sessions'
		})
	}));
	app.passport = passport
	app.use(app.router);
	app.use(express.static(config.staticPath));

	# development only
	if 'development' is app.get('env')

		app.use express.errorHandler
			dumpExceptions: true
			showStack: true

		app.use lessC
			src: config.stylesPath,
			dest: config.staticPath,
			force: true,
			prefix: "/css"


	# production only
	if  'production' and app.get 'env'
		app.use lessC({ src: config.stylesPath });
		app.use express.errorHandler();
	#merging css can be done and other tasks required in production mode
	# change the params of less-middleware to enable compression.
