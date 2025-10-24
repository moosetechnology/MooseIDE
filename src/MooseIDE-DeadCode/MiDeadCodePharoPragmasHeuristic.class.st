"
A heuristic to recognize methods with some special pragmas in Pharo.

These pragmas allow to invoke the method from the GUI
ex: <script>, <example>. <inspectorPresentationOrder:title:>,...
"
Class {
	#name : 'MiDeadCodePharoPragmasHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing' }
MiDeadCodePharoPragmasHeuristic >> description [ 

	^super description , '
	In Pharo, some pragmas mark method called by the end-user
	 (<script>, <example>. <inspectorPresentationOrder:title:>,...)'
]

{ #category : 'accessing' }
MiDeadCodePharoPragmasHeuristic >> name [

	^super name , 'Pharo: <script> pragmas'
]

{ #category : 'testing' }
MiDeadCodePharoPragmasHeuristic >> notDead: aTMethod [

	aTMethod annotationInstances ifEmpty: [ ^false ].

	^aTMethod annotationInstances anySatisfy: [ :annoInst |
		self undeadPragmas includes: (annoInst annotationType name)
	]
]

{ #category : 'accessing' }
MiDeadCodePharoPragmasHeuristic >> undeadPragmas [

	^#( example script inspectorPresentationOrder:title: worldMenu)
]
