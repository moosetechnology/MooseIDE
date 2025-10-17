Extension { #name : 'MooseObject' }

{ #category : '*MooseIDE-Core' }
MooseObject >> iconNamed: aSymbol [

	^ MiApplication current iconProvider iconNamed: aSymbol
]

{ #category : '*MooseIDE-Core' }
MooseObject >> miDescription [

	^ self description
]

{ #category : '*MooseIDE-Core' }
MooseObject >> miInspect [

	MiInspectorBrowser inspect: self
]

{ #category : '*MooseIDE-Core' }
MooseObject >> miPropagate [

	MiApplication current miPropagate: self
]

{ #category : '*MooseIDE-Core' }
MooseObject >> miPropagateOn: buses [

	MiApplication current miPropagate: self on: buses
]
