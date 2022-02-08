Extension { #name : #QueryCodePresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
QueryCodePresenter >> text [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ code text
]
