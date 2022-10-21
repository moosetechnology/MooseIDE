Class {
	#name : #MiNoteBookReport,
	#superclass : #MiPresenter,
	#instVars : [
		'menu',
		'cellList',
		'lastCellAdded',
		'interactionModel'
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

	lastCellAdded := self newTextCell.
	cellList addLast: lastCellAdded.
	self relayout.
]

{ #category : #initialization }
MiNoteBookReport >> addTextCellAfter: aCell [

	lastCellAdded := self newTextCell.
	cellList add: lastCellAdded after: aCell.
	self relayout
]

{ #category : #initialization }
MiNoteBookReport >> addTextCellBefore: aCell [

	lastCellAdded := self newTextCell.
	cellList add: lastCellAdded before: aCell.
	self relayout
]

{ #category : #initialization }
MiNoteBookReport >> initialize [

	super initialize.
	cellList := LinkedList new.
	interactionModel := MiNoteBookCodeScriptingInteractionModel new
		                    receiver: 1;
		                    yourself
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

{ #category : #accessing }
MiNoteBookReport >> mooseModel [

	self owner mooseModel
]

{ #category : #accessing }
MiNoteBookReport >> mooseModel: aMooseModel [

	interactionModel addBinding: (WorkspaceVariable  key: #mooseModel value: aMooseModel)
]

{ #category : #initialization }
MiNoteBookReport >> newCodeCell [

	^ (self instantiate: MiNoteBookCodeCell)
		  notebook: self;
		  interactionModel: interactionModel;
		  yourself
]

{ #category : #initialization }
MiNoteBookReport >> newTextCell [

	^ (self instantiate: MiNoteBookTextCell) notebook: self
]

{ #category : #adding }
MiNoteBookReport >> relayout [

	| newLayout width |
	cellList size > 1 ifTrue: [ 
		width := (cellList detect: [ :c | c textAreaWidth > 200 ]) textAreaWidth ].
	newLayout := SpBoxLayout newTopToBottom
		             spacing: 5;
		             yourself.
	cellList do: [ :cell | newLayout add: cell expand: false ].
	self layout: newLayout.
	cellList do: [ :cell | 
		width
			ifNil: [ cell updateHeight ]
			ifNotNil: [ cell updateHeight: width ] ].
	lastCellAdded takeKeyboardFocus
]

{ #category : #removing }
MiNoteBookReport >> removeCell: aCell [

	cellList remove: aCell.
	self relayout
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

{ #category : #removing }
MiNoteBookReport >> updateAll [

	self relayout.
	lastCellAdded takeKeyboardFocus
]
