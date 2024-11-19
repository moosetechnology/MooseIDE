Class {
	#name : #MooseLoadFamixCallGraphMenuCommand,
	#superclass : #MooseAbstractLoadToolMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFamixCallGraphMenuCommand class >> label [

	^ 'Java CallGraph'
]

{ #category : #'world menu' }
MooseLoadFamixCallGraphMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self 
]

{ #category : #accessing }
MooseLoadFamixCallGraphMenuCommand class >> menuPriority [

	^ super menuPriority + 1
]

{ #category : #accessing }
MooseLoadFamixCallGraphMenuCommand >> baselineName [

	^ 'FamixCallGraph'
]

{ #category : #accessing }
MooseLoadFamixCallGraphMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FamixCallGraph:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFamixCallGraphMenuCommand >> version [


	^ 'v3'
]
