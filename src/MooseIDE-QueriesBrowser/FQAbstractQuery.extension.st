Extension { #name : #FQAbstractQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ false
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> isNavigationQuery [

	^ false
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQAbstractQuery >> isScopeQuery [

	^ false
]
