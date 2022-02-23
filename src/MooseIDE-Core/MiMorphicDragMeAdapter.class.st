"
I am a morphic adapter that puts together the DragMe morph with a SpDragMe spec widget
"
Class {
	#name : #MiMorphicDragMeAdapter,
	#superclass : #SpMorphicButtonAdapter,
	#instVars : [
		'transferMorph'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #factory }
MiMorphicDragMeAdapter >> newButton [

	^ MiDragMeMorph
		  on: self
		  getState: #state
		  action: #action
		  label: #label
		  menu: #menu:
]

{ #category : #accessing }
MiMorphicDragMeAdapter >> performAction: event [

	transferMorph := self model transferPassenger build.
	transferMorph dragHand: event hand.
	transferMorph
		align: transferMorph draggedMorph topLeft
		with: event position.
	transferMorph dragTransferType: self model dragTransferType.

	event hand grabMorph: transferMorph
]

{ #category : #actions }
MiMorphicDragMeAdapter >> startDragging [

	widget startDragging
]
