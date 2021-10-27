Extension { #name : #FQComplementQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQComplementQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ numberOfQueriesInPresenter > 0
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQComplementQuery class >> miPresenterClass [

	^ MiNegationQueryPresenter
]
