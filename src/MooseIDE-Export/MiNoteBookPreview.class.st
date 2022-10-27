Class {
	#name : #MiNoteBookPreview,
	#superclass : #MiPresenter,
	#instVars : [
		'previewCells',
		'sep'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #initialization }
MiNoteBookPreview >> initialize [

	super initialize.
	previewCells := OrderedCollection new.
]

{ #category : #initialization }
MiNoteBookPreview >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: sep width: 1;
			 yourself)
]

{ #category : #initialization }
MiNoteBookPreview >> initializePresenters [

	sep := self newRoassal.
	sep canvas color: Color gray translucent.
	self initializeLayout
]

{ #category : #actions }
MiNoteBookPreview >> newPreviewCellWith: aString [

	^ (self instantiate: MiNoteBookCellPreview) text: aString
]

{ #category : #initialization }
MiNoteBookPreview >> relayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom.
	previewCells do: [ :e | newLayout add: e expand: false ].
	self layout: (SpScrollableLayout with: (SpBoxLayout newLeftToRight
				  spacing: 6;
				  add: sep width: 1;
				  add: newLayout;
				  yourself)).

	previewCells do: [ :e | e announceDisplayed ]
]

{ #category : #actions }
MiNoteBookPreview >> select: aMiNoteBookCellPreview [

	previewCells do: [ :c | c unselected ].
	aMiNoteBookCellPreview select.
	self layout withAdapterDo: [ :a | 
		aMiNoteBookCellPreview withAdapterDo: [ :b | 
			a widget scrollToShow: b widget bounds ] ]
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
