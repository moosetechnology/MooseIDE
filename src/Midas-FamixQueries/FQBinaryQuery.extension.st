Extension { #name : #FQBinaryQuery }

{ #category : #'*Midas-FamixQueries' }
FQBinaryQuery >> prepareRemovalFrom: aBrowser [
	aBrowser selectQuery: self parents anyOne.
	self prepareRemoval
]
