Extension { #name : #FQNavigationQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNavigationQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNavigationQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNavigationQuery >> isNavigationQuery [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQNavigationQuery class >> miPresenterClass [

	^ MiNavigationQueryPresenter
]
