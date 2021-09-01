Extension { #name : #MiQueriesListPresenter }

{ #category : #'*MooseIDE-NewTools-Tests' }
MiQueriesListPresenter >> parentBrowser [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ parentBrowser
]
