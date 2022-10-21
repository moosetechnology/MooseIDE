Class {
	#name : #MiNoteBookAbstractCell,
	#superclass : #MiPresenter,
	#instVars : [
		'cell',
		'icon',
		'notebook',
		'removeButton',
		'leftMenuCanvas',
		'rightMenuCanvas',
		'deleteButton',
		'addCellBellowButton',
		'addCellAboveButton'
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
			 add: leftMenuCanvas width: 30;
			 add: cell;
			 add: rightMenuCanvas width: 100;
			 yourself)
]

{ #category : #initialization }
MiNoteBookAbstractCell >> initializePresenters [

	| buttons menu |
	removeButton := self newButton
		                icon: (Smalltalk ui iconNamed: #remove);
		                action: [ self remove ].
	leftMenuCanvas := self newRoassal.
	leftMenuCanvas canvas color: Color red.
	rightMenuCanvas := self newRoassal.
	rightMenuCanvas canvas color: Color transparent.
	deleteButton := RSBox new
		                color: Color gray;
		                size: 20;
		                yourself.
	deleteButton when: RSMouseClick do: [ self remove ].

	addCellBellowButton := RSBox new
		                       color: Color gray;
		                       size: 20;
		                       yourself.
	addCellAboveButton := RSBox new
		                      color: Color gray;
		                      size: 20;
		                      yourself.
	buttons := RSGroup withAll: { 
			           deleteButton.
			           addCellBellowButton.
			           addCellAboveButton }.
	RSHorizontalLineLayout new
		alignMiddle;
		on: buttons.
	menu := RSComposite new
		        addAll: buttons;
		        isFixed: true;
		        color: Color transparent;
		        translateBy: 50 @ 14;
		        yourself.

	rightMenuCanvas canvas add: menu.
	menu adjustToChildren.
	menu padding: 10.
	addCellBellowButton
		when: RSMouseClick
		do: [ notebook addTextCellAfter: self ].
	addCellAboveButton
		when: RSMouseClick
		do: [ notebook addTextCellBefore: self ]
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook [

	^ notebook
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook: anObject [

	notebook := anObject
]

{ #category : #initialization }
MiNoteBookAbstractCell >> remove [

	notebook removeCell: self
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

{ #category : #accessing }
MiNoteBookAbstractCell >> textAreaWidth [

	self layout adapter ifNil: [ ^ -1 ].
	^ self layout adapter children second width
]

{ #category : #initialization }
MiNoteBookAbstractCell >> updateHeight [

	| textMorph height |
	self layout adapter ifNil: [ ^ self ].
	[ 
	textMorph := self layout adapter children detect: [ :c | 
		             c class = SpRubScrolledTextMorph ] ]
		on: NotFound
		do: [ ^ self ].
		
	textMorph scrollPane
		vHideScrollbar;
		vScrollbarShowNever.
	height := (RubEditingArea new
		           font: textMorph font;
		           width: textMorph width;
		           beWrapped;
		           updateTextWith: cell text) height.
	textMorph width traceCr.
	textMorph owner owner height: height
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
