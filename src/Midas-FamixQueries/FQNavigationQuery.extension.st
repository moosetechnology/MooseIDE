Extension { #name : #FQNavigationQuery }

{ #category : #'*Midas-FamixQueries' }
FQNavigationQuery class >> canBeConfigured [
	^ true
]

{ #category : #'*Midas-FamixQueries' }
FQNavigationQuery class >> color [
	"Light yellow"

	^ Color colorFrom: 'EEDD88'
]

{ #category : #'*Midas-FamixQueries' }
FQNavigationQuery >> configureIn: aCreationPresenter [
	aCreationPresenter configureNavigationQuery: self
]
