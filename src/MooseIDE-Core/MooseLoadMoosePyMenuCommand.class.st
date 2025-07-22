Class {
	#name : 'MooseLoadMoosePyMenuCommand',
	#superclass : 'MooseAbstractLoadFamixMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand class >> help [

	^ 'Famix Metamodel for Python'
]

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand class >> label [

	^ 'MoosePy'
]

{ #category : 'world menu' }
MooseLoadMoosePyMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand class >> menuPriority [

	^super menuPriority + 1
]

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand >> baselineName [

	^ 'MoosePy'
]

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/MoosePy:' , self version , '/src'
]

{ #category : 'accessing' }
MooseLoadMoosePyMenuCommand >> version [

	^ 'master'
]
