Extension { #name : #FQStringQuery }

{ #category : #'*Midas-FamixQueries' }
FQStringQuery class >> color [
	"Light blue"

	^ Color colorFrom: '77AADD'
]

{ #category : #'*Midas-FamixQueries' }
FQStringQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureStringQuery: self
]
