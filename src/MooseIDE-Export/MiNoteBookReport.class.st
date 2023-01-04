"
I am the note book editor. I am responsible to manage cells (create, delete, move, update). 
"
Class {
	#name : #MiNoteBookReport,
	#superclass : #MiPresenter,
	#instVars : [
		'menu',
		'cellList',
		'lastCellAdded',
		'selectedCell',
		'interactionModel',
		'headerSep',
		'mooseModel',
		'cellLayout',
		'browser'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #adding }
MiNoteBookReport >> add: aCell [

	self layout add: aCell expand: false.
	aCell announceDisplayed.
	lastCellAdded takeKeyboardFocus
]

{ #category : #adding }
MiNoteBookReport >> addCodeCell [

	lastCellAdded := self newCodeCell.
	cellList addLast: lastCellAdded.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #adding }
MiNoteBookReport >> addTextCell [

	lastCellAdded := self newTextCell.
	cellList addLast: lastCellAdded.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #initialization }
MiNoteBookReport >> addTextCellAfter: aCell [

	lastCellAdded := self newTextCell.
	cellList add: lastCellAdded after: aCell.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #initialization }
MiNoteBookReport >> addTextCellBefore: aCell [

	lastCellAdded := self newTextCell.
	cellList add: lastCellAdded before: aCell.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #accessing }
MiNoteBookReport >> allModelCells [

	^ cellList asOrderedCollection collect: [ :cell | cell asModelCell ]
]

{ #category : #accessing }
MiNoteBookReport >> browser [

	^ browser
]

{ #category : #accessing }
MiNoteBookReport >> browser: anObject [

	browser := anObject
]

{ #category : #accessing }
MiNoteBookReport >> cellList [

	^ cellList
]

{ #category : #initialization }
MiNoteBookReport >> defer: aBlock times: n [

	n traceCr.
	self withAdapterDo: [ :a | 
		a widget defer: [ 
			n <= 0
				ifTrue: [ a widget defer: aBlock ]
				ifFalse: [ self defer: aBlock times: n - 1 ] ] ]
]

{ #category : #accessing }
MiNoteBookReport >> headerSep [

	^ headerSep
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

	cellLayout := SpBoxLayout newTopToBottom
		              spacing: self layoutSpacing;
		              yourself.
	self layout: (SpScrollableLayout with: (SpBoxLayout newTopToBottom
				  spacing: self layoutSpacing;
				  add: headerSep height: 1;
				  add: cellLayout;
				  yourself))
]

{ #category : #initialization }
MiNoteBookReport >> initializePresenters [

	(headerSep := self newRoassal) canvas color: Color transparent.
	headerSep canvas when: RSExtentChangedEvent do: [ self updateHeight ].
	self whenDisplayDo: [ self updateHeight ].
	self initializeLayout
]

{ #category : #accessing }
MiNoteBookReport >> interactionModel [

	^ interactionModel
]

{ #category : #initialization }
MiNoteBookReport >> layoutSpacing [

	^ 10
]

{ #category : #accessing }
MiNoteBookReport >> model [

	^ self browser model
]

{ #category : #accessing }
MiNoteBookReport >> mooseModel [

	^ self owner mooseModel
]

{ #category : #accessing }
MiNoteBookReport >> mooseModel: aMooseModel [

	(self model defaultBindings) do: [ 
		:assoc | 
		interactionModel addBinding:
			(WorkspaceVariable key: assoc key asSymbol value: assoc value) ]
]

{ #category : #removing }
MiNoteBookReport >> moveDown: aCell [

	| idx |
	idx := cellList indexOf: aCell.
	idx >= cellList size ifTrue: [ ^ self ].
	cellList swap: idx with: idx + 1.
	selectedCell := aCell.
	self relayout
]

{ #category : #removing }
MiNoteBookReport >> moveUp: aCell [

	| idx |
	idx := cellList indexOf: aCell.
	idx <= 1 ifTrue: [ ^ self ].
	cellList swap: idx with: idx - 1.
	selectedCell := aCell.
	self relayout
]

{ #category : #initialization }
MiNoteBookReport >> newCodeCell [

	^ (self instantiate: MiNoteBookCodeCell)
		  notebook: self;
		  yourself
]

{ #category : #initialization }
MiNoteBookReport >> newTextCell [

	^ (self instantiate: MiNoteBookTextCell) notebook: self
]

{ #category : #adding }
MiNoteBookReport >> relayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom
		             spacing: self layoutSpacing;
		             yourself.
	cellList do: [ :cell | newLayout add: cell expand: false ].

	cellLayout removeAll.
	cellLayout add: (self newPresenter
			 layout: newLayout;
			 yourself).
	cellList do: [ :cell | cell announceDisplayed ].
	self defer: [ 
		selectedCell ifNotNil: [ self selectAndScrollTo: selectedCell ] ]
]

{ #category : #removing }
MiNoteBookReport >> removeCell: aCell [

	cellList remove: aCell.
	self relayout
]

{ #category : #adding }
MiNoteBookReport >> scrollTo: aMiNoteBookCell [

	self layout withAdapterDo: [ :a | 
		aMiNoteBookCell withAdapterDo: [ :b | 
			a widget scrollToShow: b widget bounds ] ]
]

{ #category : #removing }
MiNoteBookReport >> select: aCell [

	selectedCell := aCell.
	cellList do: [ :c | c unselect ].
	selectedCell select
]

{ #category : #adding }
MiNoteBookReport >> selectAndScrollTo: aMiNoteBookCell [

	self select: aMiNoteBookCell.
	self scrollTo: aMiNoteBookCell
]

{ #category : #adding }
MiNoteBookReport >> transformToCodeCell: aCell [

	| width |
	lastCellAdded := self newCodeCell
		                 text: aCell text;
		                 yourself.
	width := aCell textAreaWidth.
	cellList at: (cellList indexOf: aCell) put: lastCellAdded.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #adding }
MiNoteBookReport >> transformToTextCell: aCell [

	| width |
	lastCellAdded := self newTextCell
		                 text: aCell text;
		                 yourself.
	width := aCell textAreaWidth.
	cellList at: (cellList indexOf: aCell) put: lastCellAdded.
	selectedCell := lastCellAdded.
	self relayout
]

{ #category : #removing }
MiNoteBookReport >> updateAll [

	cellList := LinkedList new.
	self model cellList do: [ :c | 
		cellList add: ((self instantiate: c presenterClass)
				 notebook: self;
				 text: c text;
				 yourself) ].
	selectedCell := cellList last.
	self relayout
]

{ #category : #removing }
MiNoteBookReport >> updateHeight [

	cellList do: [ :c | c updateHeight ]
]
