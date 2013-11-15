pathInfo = {
	homePage:
		icon: 'fa-dashboard'
		href: '/dashboard'
		name: 'Dashboard'
	loginPage:
		icon: 'fa-lock'
		href: '/login'
		name: 'Login'
	registerPage:
		icon: 'fa-lock'
		href: '/signup'
		name: 'Sign up'

	servicesPage:
		icon: 'fa-lock'
		href: '/services'
		name: 'Services'
}

getBreadCrumbs = (templateName) ->
	switch templateName
		when 'loginPage' then {
			crumbs: []
			current: pathInfo.loginPage
		}
		when 'registerPage' then {
			crumbs: []
			current: pathInfo.registerPage
		}
		when 'servicesPage' then {
			crumbs: [pathInfo.homePage]
			current: pathInfo.servicesPage
		}
		else {
			crumbs: []
			current: pathInfo.homePage
		}


exports.getBreadCrumbs = getBreadCrumbs