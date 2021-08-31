Extension { #name : #MiQueryCodePresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueryCodePresenter >> text [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ code text
]
