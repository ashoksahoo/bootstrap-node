isLoggedInUser = (req, res, next)->
	if(req.session && req.session.user)
		next();
	else
		res.redirect('/signin')

exports.isLoggedInUser = isLoggedInUser;

