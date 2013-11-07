
express = require('express')
http = require('http')
passport = require('passport')

configs = require('./config/configurations')();
require('./config/mongoose')(configs)
require('./config/passport')(passport, configs)


app = express();
require('./config/express') app, configs, passport;
require('./config/router') app, configs, passport;

app.listen app.get('port'), ()->
	console.log('Express server listening on port ' + app.get('port'));

