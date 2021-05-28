Extension { #name : #FamixStAccess }

{ #category : #'*Midas-NewTools' }
FamixStAccess >> inspectorToString [

	^ self accessor parentType name asString , '>>#' , self accessor name , '>'
	  , self variable name
]
