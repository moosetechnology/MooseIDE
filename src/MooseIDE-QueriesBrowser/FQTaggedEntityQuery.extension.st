Extension { #name : #FQTaggedEntityQuery }

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTaggedEntityQuery classSide >> isAvailableForQueriesSize: numberOfQueriesInPresenter [

	^ true
]

{ #category : #'*MooseIDE-QueriesBrowser' }
FQTaggedEntityQuery classSide >> miPresenterClass [
	^ MiTaggedEntityQueryPresenter
]
