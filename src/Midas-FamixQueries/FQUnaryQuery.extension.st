Extension { #name : #FQUnaryQuery }

{ #category : #'*Midas-FamixQueries' }
FQUnaryQuery >> prepareRemovalFrom: aBrowser [
	aBrowser selectQuery: parent.
	self prepareRemoval
]
