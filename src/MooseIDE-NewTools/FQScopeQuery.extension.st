Extension { #name : #FQScopeQuery }

{ #category : #'*MooseIDE-NewTools' }
FQScopeQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*MooseIDE-NewTools' }
FQScopeQuery >> isScopeQuery [

	^ true
]

{ #category : #'*MooseIDE-NewTools' }
FQScopeQuery class >> miPresenterClass [

	^ MiScopeQueryPresenter
]
