Class {
	#name : 'MooseLoadFamixBridgeMenuCommand',
	#superclass : 'MooseAbstractLoadToolMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand class >> help [ 

	^ 'Load Famix-Bridge, a tooling solution for inter-model analysis'
]

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand class >> label [

	^ 'Famix Bridge'
]

{ #category : 'world menu' }
MooseLoadFamixBridgeMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand class >> menuPriority [

	^ super menuPriority + 1
]

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand >> baselineName [

	^ 'FamixBridge'
]

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/Famix-Bridge:', self version , '/src'
]

{ #category : 'accessing' }
MooseLoadFamixBridgeMenuCommand >> version [

	^ 'main'
]
