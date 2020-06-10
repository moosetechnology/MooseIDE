Extension { #name : #FQNumericQuery }

{ #category : #'*Midas-FamixQueries' }
FQNumericQuery class >> color [
	"Light cyan"

	^ Color colorFrom: '99DDFF'
]

{ #category : #'*Midas-FamixQueries' }
FQNumericQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureNumericQuery: self
]
