Extension { #name : #FQAbstractQuery }

{ #category : #'*Midas-FamixQueries' }
FQAbstractQuery class >> color [
	^ self subclassResponsibility
]

{ #category : #'*Midas-FamixQueries' }
FQAbstractQuery >> prepareRemovalFrom: aBrowser [
	^ self subclassResponsibility
]
