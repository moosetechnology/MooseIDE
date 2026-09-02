"
I am a command to load FAST-Python model and Tools inside of Moose. I'm exposed to the user via a menu in the menubar
"
Class {
	#name : 'MooseLoadFASTPythonMenuCommand',
	#superclass : 'MooseAbstractLoadFASTMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand class >> help [

	^ 'Famix representation of Python AST and some tooling to da analysis (CFG, SSA, Local resolution...)'
]

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand class >> label [

	^ 'FAST Python'
]

{ #category : 'world menu' }
MooseLoadFASTPythonMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand class >> menuPriority [

	^ super menuPriority + 1.5
]

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand >> baselineName [

	^ 'FASTPython'
]

{ #category : 'executing' }
MooseLoadFASTPythonMenuCommand >> execute [
	"override to load a specific group of the baseline: #all"

	Metacello new
		baseline: self baselineName;
		repository: self repositoryURL;
		onConflictUseIncoming;
		load: #all
]

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST-Python' , self version , '/src'
]

{ #category : 'accessing' }
MooseLoadFASTPythonMenuCommand >> version [

	^ 'main'
]
