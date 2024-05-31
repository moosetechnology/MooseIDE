Extension { #name : #MooseObject }

{ #category : #'*MooseIDE-Core' }
MooseObject >> iconNamed: aSymbol [

	^ MiApplication current iconProvider iconNamed: aSymbol
]

{ #category : #'*MooseIDE-Core' }
MooseObject >> miDescription [

	^ self description
]

{ #category : #'*MooseIDE-Core' }
MooseObject >> miPropagate [

	(MiApplication current busNamed: MiApplication defaultBusName)
		globallySelect: self
]

{ #category : #'*MooseIDE-Core' }
MooseObject >> miPropagateOn: buses [

	buses do: [ :bus | bus globallySelect: self ]
]
