Extension { #name : #FQUnaryQuery }

{ #category : #'*Midas-FamixQueries' }
FQUnaryQuery class >> canBeConfigured [
	^ false
]

{ #category : #'*Midas-FamixQueries' }
FQUnaryQuery >> prepareRemovalFrom: aBrowser [
	aBrowser selectQuery: parent.
	self prepareRemoval
]
