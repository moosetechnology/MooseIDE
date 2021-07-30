Extension { #name : #FamixStAccess }

{ #category : #'*MooseIDE-NewTools' }
FamixStAccess >> inspectorToString [

	^ self accessor parentType name asString , '>>#' , self accessor name , '>'
	  , self variable name
]
