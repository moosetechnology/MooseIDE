Class {
	#name : #MiNoteBookAbstractCell,
	#superclass : #MiPresenter,
	#instVars : [
		'cell',
		'icon',
		'notebook'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #api }
MiNoteBookAbstractCell >> beCode [

	self subclassResponsibility
]

{ #category : #api }
MiNoteBookAbstractCell >> beText [

	self subclassResponsibility
]

{ #category : #initialization }
MiNoteBookAbstractCell >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 7;
			 add: icon expand: false;
			 add: cell;
			 yourself)
]

{ #category : #initialization }
MiNoteBookAbstractCell >> initializePresenters [

	
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook [

	^ notebook
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook: anObject [

	notebook := anObject
]

{ #category : #protocol }
MiNoteBookAbstractCell >> takeKeyboardFocus [

	cell takeKeyboardFocus
]

{ #category : #initialization }
MiNoteBookAbstractCell >> text [

	^ cell text
]

{ #category : #initialization }
MiNoteBookAbstractCell >> text: aText [

	cell text: aText
]

{ #category : #'as yet unclassified' }
MiNoteBookAbstractCell >> textAreaWidth [

	^ self layout adapter children second width
]

{ #category : #initialization }
MiNoteBookAbstractCell >> updateHeight [

	self updateHeight: self textAreaWidth
]

{ #category : #initialization }
MiNoteBookAbstractCell >> updateHeight: width [

	| textMorph height |
	(self layout adapter isNil or: [ 
		 self layout adapter children size < 2 ]) ifTrue: [ ^ self ].

	textMorph := self layout adapter children second.
	textMorph scrollPane
		vHideScrollbar;
		vScrollbarShowNever.
	height:= (RubEditingArea new
			 font: textMorph font;
			 width: width;
			 beWrapped;
			 updateTextWith: cell text) height.
	textMorph width traceCr.
	textMorph owner owner height: height
]

{ #category : #enumerating }
MiNoteBookAbstractCell >> whenTextChangedDo: aBlock [

	cell whenTextChangedDo: aBlock
]
