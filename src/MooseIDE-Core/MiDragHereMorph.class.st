"
I am a morphic pane that implements that allows the definition of accepting or rejecting drops according to valuable objects (block by example )
"
Class {
	#name : #MiDragHereMorph,
	#superclass : #PanelMorph,
	#instVars : [
		'onPrompteForDragging',
		'onPrompteForAccepting'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #'as yet unclassified' }
MiDragHereMorph >> acceptDroppingMorph: aBlock [

	onPrompteForAccepting := aBlock
]

{ #category : #'as yet unclassified' }
MiDragHereMorph >> acceptDroppingMorph: aTransferMorph event: anEvent [

	^ onPrompteForAccepting ifNotNil: [ 
		  onPrompteForAccepting cull: aTransferMorph cull: anEvent ]
]

{ #category : #'as yet unclassified' }
MiDragHereMorph >> wantsDroppedMorph: aBlock [ 
	onPrompteForDragging := aBlock
]

{ #category : #'as yet unclassified' }
MiDragHereMorph >> wantsDroppedMorph: aMorph event: evt [

	^ onPrompteForDragging
		  ifNil: [ self dropEnabled ]
		  ifNotNil: [ onPrompteForDragging cull: aMorph cull: evt ]
]
