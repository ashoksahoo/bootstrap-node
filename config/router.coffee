module.exports = (app, config, passport) ->
	fs = require('fs')
	path = require('path')
	logger = config.logger;
	mod_dir = fs.readdirSync(config.modulePath);
	mod_dir.forEach (file) ->
		dirPath = path.join(config.modulePath, file);
		stat = fs.statSync(dirPath);
		if stat and stat.isDirectory()
			routerPath = path.join(dirPath, 'router.coffee');
			if fs.existsSync routerPath
				try
					require(routerPath) app, passport
				catch error
					logger.error error