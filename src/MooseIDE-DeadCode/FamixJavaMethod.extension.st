Extension { #name : 'FamixJavaMethod' }

{ #category : '*MooseIDE-DeadCode' }
FamixJavaMethod >> isDefaultConstructor [

	self isConstructor ifFalse: [ ^false ].
	self parameters ifNotEmpty: [ ^false ].

	^true
]

{ #category : '*MooseIDE-DeadCode' }
FamixJavaMethod >> signatureMatch: aTMethod [

	^signature = aTMethod signature

	"(self declaredType = aTMethod declaredType)
		ifFalse: [ ^false ].

	parameters with: aTMethod parameters do: [ :p1 :p2 |
		(p1 declaredType = p2 declaredType)
			ifFalse: [ ^false ] ].

	^true"
]
