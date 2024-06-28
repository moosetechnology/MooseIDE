Class {
	#name : #MooseLoadFASTPharoMenuCommand,
	#superclass : #MooseAbstractLoadFASTMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand class >> help [

	^ 'Famix representation of Pharo AST'
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand class >> label [

	^ 'FAST Pharo'
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand class >> menuPriority [

	^ super menuPriority + 2
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand >> baselineName [

	^ 'FASTPharo'
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST-Pharo:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFASTPharoMenuCommand >> version [

	^ 'v2'
]
