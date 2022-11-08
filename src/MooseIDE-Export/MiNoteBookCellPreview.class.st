"
I am a preview cell presenter. I am linked to a cell presenter and used to dispay its content in the preview area.
"
Class {
	#name : #MiNoteBookCellPreview,
	#superclass : #MiPresenter,
	#instVars : [
		'textPresenter',
		'cell',
		'parent'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #actions }
MiNoteBookCellPreview >> beSelected [
	
	self parent select: self.
	
]

{ #category : #accessing }
MiNoteBookCellPreview >> cell [

	^ cell
]

{ #category : #accessing }
MiNoteBookCellPreview >> cell: anObject [

	cell := anObject
]

{ #category : #initialization }
MiNoteBookCellPreview >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: textPresenter;
			 yourself)
]

{ #category : #initialization }
MiNoteBookCellPreview >> initializePresenters [

	textPresenter := self newText
		                 beNotEditable;
		                 yourself.
	self whenDisplayDo: [ 
		self updateHeight.
		textPresenter withAdapterDo: [ :a | 
			UIManager default defer: [ 
				a widget backgroundColor: self unselectedColor ] ] ].
	self initializeLayout.
	textPresenter eventHandler whenMouseDownDo: [ :anEvent | 
		self selectMe ]
]

{ #category : #initialization }
MiNoteBookCellPreview >> morphFor: aPresenter from: aMorph [

	aMorph presenter = aPresenter ifTrue: [ ^ aMorph ].
	aMorph owner ifNil: [ ^ nil ].
	^ self morphFor: aPresenter from: aMorph owner
]

{ #category : #accessing }
MiNoteBookCellPreview >> parent [

	^ parent
]

{ #category : #accessing }
MiNoteBookCellPreview >> parent: anObject [

	parent := anObject
]

{ #category : #actions }
MiNoteBookCellPreview >> select [

	textPresenter withAdapterDo: [ :a | 
		a widget backgroundColor: (Color fromHexString: '77A8C8') ]
]

{ #category : #actions }
MiNoteBookCellPreview >> selectAndScrollToMe [

	self parent selectAndScrollTo: self
]

{ #category : #actions }
MiNoteBookCellPreview >> selectMe [
	
	self parent select: self.
	cell ifNotNil: [ :c | c selectAndScrollToMe ]
]

{ #category : #accessing }
MiNoteBookCellPreview >> text: aString [

	textPresenter text: aString
]

{ #category : #actions }
MiNoteBookCellPreview >> unselected [
	
	textPresenter withAdapterDo: [ :a | a widget backgroundColor: self unselectedColor ]
]

{ #category : #initialization }
MiNoteBookCellPreview >> unselectedColor [

	^ Smalltalk ui theme baseColor
]

{ #category : #initialization }
MiNoteBookCellPreview >> updateHeight [

	UIManager default defer: [ 
		textPresenter withAdapterDo: [ :a | 
			a widget defer: [ 
				a widget scrollPane textArea withoutSelectionBar.
				self withAdapterDo: [ :b | 
					b widget height: a widget scrollPane textArea height ] ] ] ]
]
