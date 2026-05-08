"
A heuristic to recognize methods with some special pragmas in Pharo.

These pragmas allow to invoke the method from the GUI
ex: <script>, <example>. <inspectorPresentationOrder:title:>,...
"
Class {
	#name : 'MiDeadPharoPragmasRule',
	#superclass : 'MiDeadAbstractPharoRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadPharoPragmasRule >> name [

	^super name , '<script> pragmas'
]

{ #category : 'testing' }
MiDeadPharoPragmasRule >> notDead: aTMethod [

	aTMethod annotationInstances ifEmpty: [ ^false ].

	^aTMethod annotationInstances anySatisfy: [ :annoInst |
		self undeadPragmas includes: (annoInst annotationType name)
	]
]

{ #category : 'accessing' }
MiDeadPharoPragmasRule >> undeadPragmas [

	^#( example script inspectorPresentationOrder:title: worldMenu)
]
