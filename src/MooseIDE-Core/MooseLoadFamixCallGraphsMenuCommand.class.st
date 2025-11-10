Class {
	#name : 'MooseLoadFamixCallGraphsMenuCommand',
	#superclass : 'MooseAbstractLoadToolMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand class >> help [

	^ 'Load the call graphs builder for Java in its second version. This is currently a work in progress.'
]

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand class >> label [

	^ 'Famix Java call graphs v2 (work in progress)'
]

{ #category : 'world menu' }
MooseLoadFamixCallGraphsMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand class >> menuPriority [

	^ super menuPriority + 2
]

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand >> baselineName [

	^ 'FamixCallGraphs'
]

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand >> repositoryURL [

	^ 'github://jecisc/FamixCallGraphs:' , self version , '/src'
]

{ #category : 'accessing' }
MooseLoadFamixCallGraphsMenuCommand >> version [

	^ 'main'
]
