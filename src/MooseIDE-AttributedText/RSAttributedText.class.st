"
TODO
"
Class {
	#name : #RSAttributedText,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'text',
		'attributes'
	],
	#category : #'MooseIDE-AttributedText'
}

{ #category : #adding }
RSAttributedText >> addAttribute: attribute [
	attributes add: attribute.
]

{ #category : #adding }
RSAttributedText >> addAttribute: attribute from: from to: to [
	attribute
		from: from;
		to: to.
	self addAttribute: attribute.
]

{ #category : #hooks }
RSAttributedText >> canvasController [
	| c |
	c := RSCanvasController simple.
	c interactions removeKey: RSZoomableCanvasInteraction.
	c interactions removeKey:  RSDraggableCanvasInteraction.
	c interactions at: RSScrollWheelCanvasInteraction put: RSScrollWheelCanvasInteraction new.
	c configuration 
		padding: 10;
		hasHorizontalScrolling: false.
	^ c
	
]

{ #category : #initialization }
RSAttributedText >> initialize [
	super initialize.
	attributes := OrderedCollection new.
]

{ #category : #hooks }
RSAttributedText >> renderAttributes: comp [
	attributes do: [ :att | att renderIn: comp ].
]

{ #category : #hooks }
RSAttributedText >> renderIn: aCanvas [
	| theme b comp |
	theme := Smalltalk ui theme.
	aCanvas color: theme backgroundColor.
	b := RSMultilineLabelBuilder new.
	b layout: (RSVerticalLineLayout new gapSize: 1).
	b labelShape color: theme textColor.
	comp := b shapeFor: text.
	comp model: text.
	self renderAttributes: comp.
	aCanvas add: comp.
	
	aCanvas @ self canvasController.
	
]

{ #category : #accessing }
RSAttributedText >> text [
	^ text
]

{ #category : #accessing }
RSAttributedText >> text: aString [
	text := aString ,' '
]
