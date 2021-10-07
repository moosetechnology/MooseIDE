Extension { #name : #MiQueriesListPresenter }

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueriesListPresenter >> componentList [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ componentListPresenter
]

{ #category : #'*MooseIDE-QueriesBrowser-Tests' }
MiQueriesListPresenter >> queryCounter [
	^ queryCounter
]
