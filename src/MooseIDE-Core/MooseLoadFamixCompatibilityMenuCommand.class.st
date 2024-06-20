Class {
	#name : #MooseLoadFamixCompatibilityMenuCommand,
	#superclass : #MooseAbstractLoadModuleMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand class >> help [

	^ 'Old Famix Metamodel - Not maintained anymore'
]

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand class >> label [

	^ 'Famix-Compatibility'
]

{ #category : #'world menu' }
MooseLoadFamixCompatibilityMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) withSeparatorAfter
]

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand class >> menuPriority [

	^ 22
]

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand >> baselineName [

	^ 'FamixCompatibility'
]

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAMIX-Compatibility:' , self version
	  , '/src'
]

{ #category : #accessing }
MooseLoadFamixCompatibilityMenuCommand >> version [

	^ 'main'
]
