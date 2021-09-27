Extension { #name : #FQTypeQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTypeQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTypeQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTypeQuery class >> miPresenterClass [

	^ MiTypeQueryPresenter
]
