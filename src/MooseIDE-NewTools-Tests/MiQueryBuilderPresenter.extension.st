Extension { #name : #MiQueryBuilderPresenter }

{ #category : #'*MooseIDE-NewTools-Tests' }
MiQueryBuilderPresenter >> parentBrowser [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ parentBrowser
]
