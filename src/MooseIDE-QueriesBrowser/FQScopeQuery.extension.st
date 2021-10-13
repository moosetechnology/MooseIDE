Extension { #name : #FQScopeQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQScopeQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQScopeQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQScopeQuery >> isScopeQuery [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQScopeQuery class >> miPresenterClass [

	^ MiScopeQueryPresenter
]
