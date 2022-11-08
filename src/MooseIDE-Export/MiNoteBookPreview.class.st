"
I am a preview of the document. I am responsible to create preview cells and connect them with there cell presenters.
"
Class {
	#name : #MiNoteBookPreview,
	#superclass : #MiPresenter,
	#instVars : [
		'previewCells',
		'sep',
		'browser',
		'topMenu',
		'closeButton',
		'mainLayout',
		'scrollLayout'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #accessing }
MiNoteBookPreview >> browser [

	^ browser
]

{ #category : #accessing }
MiNoteBookPreview >> browser: anObject [

	browser := anObject
]

{ #category : #initialization }
MiNoteBookPreview >> close [

	browser closePreview
]

{ #category : #initialization }
MiNoteBookPreview >> initialize [

	super initialize.
	previewCells := OrderedCollection new.
]

{ #category : #initialization }
MiNoteBookPreview >> initializeLayout [

	mainLayout := SpBoxLayout newTopToBottom
		              add: self newRoassal;
		              yourself.
	scrollLayout := SpScrollableLayout with: (self newPresenter
			                 layout: mainLayout;
			                 yourself).
	self layout: (SpBoxLayout newLeftToRight
			 spacing: 6;
			 add: sep width: 1;
			 add: (SpBoxLayout newTopToBottom
					  add: topMenu height: 16;
					  add: scrollLayout;
					  yourself);
			 yourself)
]

{ #category : #initialization }
MiNoteBookPreview >> initializePresenters [

	sep := self newRoassal.
	sep canvas color: Color gray translucent.
	sep canvas when: RSExtentChangedEvent do: [ self updateHeight ].
	topMenu := self newRoassal.
	topMenu canvas color: Color transparent.
	closeButton := RSBitmap new
		               form: (Smalltalk ui icons iconNamed: #windowClose);
		               model: 'Delete';
		               size: 16;
		               yourself.
	topMenu canvas add: closeButton.
	closeButton
		setAsFixed;
		translateBy: 8 @ 8.
	closeButton when: RSMouseClick do: [ self close ].
	self whenDisplayDo: [ self relayout ].
	self initializeLayout
]

{ #category : #actions }
MiNoteBookPreview >> newPreviewCellWith: aString [

	^ (self instantiate: MiNoteBookCellPreview)
		  text: aString;
		  parent: self;
		  yourself
]

{ #category : #initialization }
MiNoteBookPreview >> relayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom.
	previewCells do: [ :e | newLayout add: e expand: false ].

	scrollLayout child layout: newLayout.
	previewCells do: [ :e | e announceDisplayed ]
]

{ #category : #actions }
MiNoteBookPreview >> scrollTo: aMiNoteBookCellPreview [

	scrollLayout withAdapterDo: [ :a | 
		aMiNoteBookCellPreview withAdapterDo: [ :b | 
			a widget scrollToShow: b widget bounds ] ]
]

{ #category : #actions }
MiNoteBookPreview >> select: aMiNoteBookCellPreview [

	previewCells do: [ :c | c unselected ].
	aMiNoteBookCellPreview select.
]

{ #category : #actions }
MiNoteBookPreview >> selectAndScrollTo: aMiNoteBookCellPreview [

	self select: aMiNoteBookCellPreview.
	self scrollTo: aMiNoteBookCellPreview
]

{ #category : #initialization }
MiNoteBookPreview >> updateHeight [

	previewCells do: [ :c | c updateHeight ]
]

{ #category : #actions }
MiNoteBookPreview >> updateWithStringCollection: aCollection [

	previewCells := aCollection collect: [ :s | 
		                self newPreviewCellWith: s ].
	self relayout
]

{ #category : #actions }
MiNoteBookPreview >> updateWithStringCollection: aCollection andCells: cells [

	| col |
	col := OrderedCollection new.
	aCollection withIndexDo: [ :e :i | 
		| cell pCell |
		cell := cells at: i.
		pCell := self newPreviewCellWith: (aCollection at: i).
		pCell cell: cell.
		cell previewCell: pCell.
		col add: pCell ].
	previewCells := col.
	self relayout
]
