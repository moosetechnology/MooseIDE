Extension { #name : #FQIntersectionQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQIntersectionQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ numberOfQueriesInPresenter > 1
]
