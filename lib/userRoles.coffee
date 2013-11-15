module.exports =
	Free : 'free'
	Premium : 'premium'
	Affiliate : 'affiliate'
	Admin : 'admin'
	Merchant : 'merchant'
	isFreeAccount: (role)->
		return not role or role is '' or role is 'free'
