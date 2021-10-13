Extension { #name : #FQSubtractionQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQSubtractionQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ numberOfQueriesInPresenter > 1
]
