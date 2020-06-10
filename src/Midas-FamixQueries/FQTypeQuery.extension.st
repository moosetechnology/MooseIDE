Extension { #name : #FQTypeQuery }

{ #category : #'*Midas-FamixQueries' }
FQTypeQuery class >> color [
	"Pear"

	^ Color colorFrom: 'BBCC33'
]

{ #category : #'*Midas-FamixQueries' }
FQTypeQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureTypeQuery: self
]
