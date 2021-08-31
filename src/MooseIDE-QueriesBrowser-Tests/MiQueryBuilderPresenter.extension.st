Extension { #name : #MiQueryBuilderPresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueryBuilderPresenter >> componentList [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ componentListPresenter
]
