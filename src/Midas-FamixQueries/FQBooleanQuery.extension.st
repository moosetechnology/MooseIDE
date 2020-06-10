Extension { #name : #FQBooleanQuery }

{ #category : #'*Midas-FamixQueries' }
FQBooleanQuery class >> color [
	"Mint"

	^ Color colorFrom: '44BB99'
]

{ #category : #'*Midas-FamixQueries' }
FQBooleanQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureBooleanQuery: self
]
