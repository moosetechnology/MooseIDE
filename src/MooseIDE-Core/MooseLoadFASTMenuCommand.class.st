Class {
	#name : #MooseLoadFASTMenuCommand,
	#superclass : #MooseAbstractLoadFASTMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFASTMenuCommand class >> help [

	^ 'Famix AST Metamodel'
]

{ #category : #accessing }
MooseLoadFASTMenuCommand class >> label [

	^ 'FAST Core'
]

{ #category : #'world menu' }
MooseLoadFASTMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : #accessing }
MooseLoadFASTMenuCommand class >> menuPriority [

	^ super menuPriority + 1
]

{ #category : #accessing }
MooseLoadFASTMenuCommand >> baselineName [

	^ 'FAST'
]

{ #category : #accessing }
MooseLoadFASTMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFASTMenuCommand >> version [

	^ 'v2.x.x'
]
