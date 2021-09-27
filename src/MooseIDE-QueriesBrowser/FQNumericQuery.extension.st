Extension { #name : #FQNumericQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNumericQuery class >> canBeConfigured [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNumericQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNumericQuery class >> miPresenterClass [

	^ MiNumericQueryPresenter
]
