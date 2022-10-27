Class {
	#name : #MiNoteBookCellPreview,
	#superclass : #MiPresenter,
	#instVars : [
		'textPresenter',
		'cell'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #actions }
MiNoteBookCellPreview >> beSelected [

	self owner select: self.
	"cell ifNotNil: [ :c | c beSelected ]"
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

	textPresenter := self newText.
	textPresenter beNotEditable.
	self whenDisplayDo: [ 
		self updateHeight.
		textPresenter withAdapterDo: [ :a | 
			a widget backgroundColor: self unselectedColor ] ].
	self initializeLayout.
	textPresenter eventHandler whenMouseDownDo: [ self beSelected ]
]

{ #category : #initialization }
MiNoteBookCellPreview >> morphFor: aPresenter from: aMorph [

	aMorph presenter = aPresenter ifTrue: [ ^ aMorph ].
	aMorph owner ifNil: [ ^ nil ].
	^ self morphFor: aPresenter from: aMorph owner
]

{ #category : #actions }
MiNoteBookCellPreview >> select [

	textPresenter withAdapterDo: [ :a | 
		a widget backgroundColor: (Color fromHexString: '77A8C8') ]
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

	textPresenter withAdapterDo: [ :a | 
		a widget defer: [
			a widget scrollPane textArea height traceCr.
			self withAdapterDo: [ :b | 
				b widget height: a widget scrollPane textArea height ] ] ]
]
