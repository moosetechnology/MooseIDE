Class {
	#name : #MooseLoadMoosePyMenuCommand,
	#superclass : #MooseAbstractLoadFamixMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadMoosePyMenuCommand class >> help [

	^ 'Famix Metamodel for Python'
]

{ #category : #accessing }
MooseLoadMoosePyMenuCommand class >> label [

	^ 'MoosePy'
]

{ #category : #accessing }
MooseLoadMoosePyMenuCommand class >> menuPriority [

	^super menuPriority + 1
]

{ #category : #accessing }
MooseLoadMoosePyMenuCommand >> baselineName [

	^ 'MoosePy'
]

{ #category : #accessing }
MooseLoadMoosePyMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/MoosePy:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadMoosePyMenuCommand >> version [

	^ 'master'
]
