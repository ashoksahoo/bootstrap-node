$(document).ready(function () {
	authorizationSetup();
});

function authorizationSetup() {
	var authPage = $('.auth-page');
	if (authPage.length == 0)
		return;

	$('.social-login').click(function () {
		window.location.href = '/auth/' + $(this).attr('data-endpoint');
	});

	var rightMenu = $('ul.navbar-right');
	rightMenu.find('a.signup-link').click(function () {
		window.location.href = '/signup';
	});
	rightMenu.find('a.login-link').click(function () {
		window.location.href = '/login';
	});

	loginSetup();
	signupSetup();
}

function loginSetup() {
	var loginPage = $('.login-page');
	if (loginPage.length == 0)
		return;

}

function isEmptyString(str) {
	return !str || str == '';
}

function signupSetup() {
	var signupPage = $('.signup-page');
	if (signupPage.length == 0)
		return;

	var form = $('#signup-form');
	form.ajaxForm({
		beforeSubmit: function (formData, jqForm, options) {
			var name = form.find('#name-input').val();
			growls.hideAll();
			if (isEmptyString(name)) {
				growls.showError('Please enter your name');
				return false;
			}
			var email = form.find('#email-input').val();
			if (isEmptyString(email)) {
				growls.showError('Please enter a valid email');
				return false;
			}
			var mobile = form.find('#mobile-input').val();
			if (isEmptyString(mobile)) {
				growls.showError('Please enter valid mobile number');
				return false;
			}
			var password = form.find('#password-input').val();
			if (isEmptyString(password) || password.length < 6) {
				growls.showError('Please choose a password with minimum 6 characters');
				return false;
			}

			var password2 = form.find('#password-input-2').val();
			if (isEmptyString(password2) || password != password2) {
				growls.showError('Passwords do not match. Re-enter the same password to confirm');
				return false;
			}
		},
		success: function (response, status) {
			if (response.code == 1)
				window.location.href = response.data;
			else
				growls.showError(response.message)
		}

	});
}