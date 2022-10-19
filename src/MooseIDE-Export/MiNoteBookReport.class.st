Class {
	#name : #MiNoteBookReport,
	#superclass : #MiPresenter,
	#instVars : [
		'menu',
		'cellList',
		'lastCellAdded'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #adding }
MiNoteBookReport >> addCodeCell [

	lastCellAdded := self newCodeCell.
	cellList addLast: lastCellAdded.
	self relayout
]

{ #category : #adding }
MiNoteBookReport >> addTextCell [

	| width |
	cellList notEmpty ifTrue: [ 
		width := (cellList at: 1) textAreaWidth ].
	lastCellAdded := self newTextCell.
	cellList addLast: lastCellAdded.
	self relayout.
	cellList do: [ :cell | 
		width
			ifNil: [ cell updateHeight ]
			ifNotNil: [ cell updateHeight: width ] ]
]

{ #category : #initialization }
MiNoteBookReport >> initialize [

	super initialize.
	cellList := LinkedList new.
]

{ #category : #initialization }
MiNoteBookReport >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (self newButton
					  hide;
					  yourself)
			 expand: false;
			 yourself)
]

{ #category : #initialization }
MiNoteBookReport >> initializePresenters [

	self initializeLayout
]

{ #category : #initialization }
MiNoteBookReport >> newCodeCell [

	^ (self instantiate: MiNoteBookCodeCell) notebook: self
]

{ #category : #initialization }
MiNoteBookReport >> newTextCell [

	^ (self instantiate: MiNoteBookTextCell) notebook: self
]

{ #category : #adding }
MiNoteBookReport >> relayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom
		             spacing: 5;
		             yourself.
	cellList do: [ :cell | 
		cell whenTextChangedDo: [  ].
		newLayout add: cell expand: false ].
	self layout: newLayout.
	cellList do: [ :cell | cell whenTextChangedDo: [ cell updateHeight ] ].
	lastCellAdded takeKeyboardFocus
]

{ #category : #adding }
MiNoteBookReport >> transformToCodeCell: aCell [

	| width |
	lastCellAdded := self newCodeCell
		                 text: aCell text;
		                 yourself.
	width := aCell textAreaWidth.
	cellList at: (cellList indexOf: aCell) put: lastCellAdded.
	self layout replace: aCell with: lastCellAdded.
	lastCellAdded updateHeight: width
]

{ #category : #adding }
MiNoteBookReport >> transformToTextCell: aCell [

	| width |
	lastCellAdded := self newTextCell
		                 text: aCell text;
		                 yourself.
	width := aCell textAreaWidth.
	cellList at: (cellList indexOf: aCell) put: lastCellAdded.
	self layout replace: aCell with: lastCellAdded.
	lastCellAdded updateHeight: width
]
