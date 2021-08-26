Extension { #name : #FQNavigationQuery }

{ #category : #'*MooseIDE-NewTools' }
FQNavigationQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*MooseIDE-NewTools' }
FQNavigationQuery >> isNavigationQuery [

	^ true
]

{ #category : #'*MooseIDE-NewTools' }
FQNavigationQuery class >> miPresenterClass [

	^ MiNavigationQueryPresenter
]
