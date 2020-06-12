Extension { #name : #FQScopeQuery }

{ #category : #'*Midas-FamixQueries' }
FQScopeQuery class >> color [
	"Blue-green"

	^ Color colorFrom: '009292'
]

{ #category : #'*Midas-FamixQueries' }
FQScopeQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureScopeQuery: self
]
