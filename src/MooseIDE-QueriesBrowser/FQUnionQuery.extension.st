Extension { #name : #FQUnionQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQUnionQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ numberOfQueriesInPresenter > 1
]
