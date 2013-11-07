module.exports = (config) ->
	fs = require 'fs'
	mongoose = require 'mongoose'

	mongoose.connect config.db

	# Bootstrap models
	models_path = config.rootPath + "/app/models"
	fs.readdirSync(models_path).forEach (file) ->
		require models_path + "/" + file  if ~file.indexOf(".coffee")
