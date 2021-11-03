Class {
	#name : #MiDragMeMorph,
	#superclass : #DragMe,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #actions }
MiDragMeMorph >> startDragging [

	| event |
	event := UIManager default currentWorld worldState activeHand lastEvent.
	self performAction: (MouseButtonEvent new
			 setType: #mouseDown
			 position: (event position)
			 which: MouseEvent redButton
			 buttons: MouseEvent redButton
			 hand: UIManager default currentWorld worldState activeHand
			 stamp: Time millisecondClockValue) "Some Morphs report local coords"
]
