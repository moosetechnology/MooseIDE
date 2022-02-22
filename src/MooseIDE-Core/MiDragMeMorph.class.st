"
I am a morph that represents a button (kind of a clickable something) with all the configuration ready to activate ""start dragging"" feature.
"
Class {
	#name : #MiDragMeMorph,
	#superclass : #PluggableButtonMorph,
	#instVars : [
		'draggingAction'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #accessing }
MiDragMeMorph >> badgeSelector: aString [ 

]

{ #category : #configuring }
MiDragMeMorph >> configureWith: displayModel item: itemPresenter [
	displayModel configureButton: self item: itemPresenter
]

{ #category : #accessing }
MiDragMeMorph >> getIconSelector: aSelector [

]

{ #category : #accessing }
MiDragMeMorph >> getLabelSelector: aSelector [

	getLabelSelector := aSelector.
	self update: getLabelSelector
]

{ #category : #initialization }
MiDragMeMorph >> initialize [

	super initialize.

	label := StringMorph
		         contents: 'DragMe'
		         font: StandardFonts buttonFont.
	self extent: label width + 6 @ (label height + 6).
	label position: self center - (label extent // 2).
	self addMorph: label.
	label lock
]

{ #category : #'event handling' }
MiDragMeMorph >> performAction: event [

	"Inform the model that this button has been pressed. Sent by the controller when this button is pressed. If the button's actionSelector takes any arguments, they are obtained dynamically by sending the argumentSelector to the argumentsProvider"

	enabled ifFalse: [ ^ self ].
	askBeforeChanging ifTrue: [ model okToChange ifFalse: [ ^ self ] ].
	self actionBlock ifNotNil: [ ^ self actionBlock cull: event ].
	model performAction: event
]

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

{ #category : #'event handling' }
MiDragMeMorph >> whenDraggingDo: aBlock [

	draggingAction := aBlock
]
