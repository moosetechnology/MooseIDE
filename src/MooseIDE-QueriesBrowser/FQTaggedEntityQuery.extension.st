Extension { #name : #FQTaggedEntityQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTaggedEntityQuery class >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTaggedEntityQuery class >> miPresenterClass [
	^ MiTaggedEntityQueryPresenter
]
