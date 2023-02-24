"
I am an abstract class for note book cells presenters.
I am responsible to adapt my size according to the text contaied in my text presenter.
"
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
		'addCellAboveButton',
		'moveCellUp',
		'moveCellDown',
		'previewCell'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #converting }
MiNoteBookAbstractCell >> asModelCell [

	self subclassResponsibility
]

{ #category : #api }
MiNoteBookAbstractCell >> beCode [

	self subclassResponsibility
]

{ #category : #initialization }
MiNoteBookAbstractCell >> beSelected [

	notebook select: self.
	previewCell ifNotNil: [ :c | c beSelected ]
]

{ #category : #api }
MiNoteBookAbstractCell >> beText [

	self subclassResponsibility
]

{ #category : #initialization }
MiNoteBookAbstractCell >> beUnselected [

	leftMenuCanvas canvas color: self unselectedColor.
	leftMenuCanvas canvas signalUpdate.
	rightMenuCanvas canvas color: self unselectedColor.
	rightMenuCanvas canvas signalUpdate
]

{ #category : #accessing }
MiNoteBookAbstractCell >> cell [

	^ cell
]

{ #category : #initialization }
MiNoteBookAbstractCell >> createDescriptionFor: aString [

	^ aString asTextMorph
		  backgroundColor: (Color white alpha: 0.6);
		  borderColor: Color gray;
		  textColor: Color black;
		  borderWidth: 1;
		  margins: 2;
		  yourself
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
	self whenDisplayDo: [ 
		self withAdapterDo: [ 
			self adapter children second textArea announcer
				when: MorphGotFocus
				do: [ self selectMe ] ].
		self updateHeight ].
	removeButton := self newButton
		                icon: (Smalltalk ui iconNamed: #remove);
		                action: [ self remove ].
	leftMenuCanvas := self newRoassal.
	leftMenuCanvas canvas color: self unselectedColor.
	rightMenuCanvas := self newRoassal.
	rightMenuCanvas canvas color: Color transparent.
	deleteButton := RSBitmap new
		                form: (self iconNamed: #mooseTrash);
		                model: 'Delete';
		                size: 16;
		                yourself.
	deleteButton when: RSMouseClick do: [ self remove ].

	addCellBellowButton := RSBitmap new
		                       form: (self iconNamed: #mooseAddBellow);
		                       model: 'Add after';
		                       size: 16;
		                       yourself.
	addCellAboveButton := RSBitmap new
		                      form: (self iconNamed: #mooseAddAbove);
		                      model: 'Add before';
		                      size: 16;
		                      yourself.
	moveCellUp := RSBitmap new
		              form: (self iconNamed: #mooseUp);
		              model: 'Move up cell';
		              size: 16;
		              yourself.
	moveCellDown := RSBitmap new
		                form: (self iconNamed: #mooseDown);
		                model: 'Move down cell';
		                size: 16;
		                yourself.
	buttons := RSGroup withAll: { 
			           moveCellUp.
			           moveCellDown.
			           addCellBellowButton.
			           addCellAboveButton.

			           deleteButton }.
	buttons @ (RSMorphicPopupInteraction new
		 morphBuilder: [ :model | self createDescriptionFor: model ];
		 yourself).
	RSHorizontalLineLayout new
		alignMiddle;
		horizontalGap: 2;
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
	moveCellUp when: RSMouseClick do: [ self moveUp ].
	moveCellDown when: RSMouseClick do: [ self moveDown ].
	addCellBellowButton
		when: RSMouseClick
		do: [ notebook addTextCellAfter: self ].
	addCellAboveButton
		when: RSMouseClick
		do: [ notebook addTextCellBefore: self ]
]

{ #category : #initialization }
MiNoteBookAbstractCell >> moveDown [

	notebook moveDown: self
]

{ #category : #initialization }
MiNoteBookAbstractCell >> moveUp [
	
	notebook moveUp: self
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook [

	^ notebook
]

{ #category : #accessing }
MiNoteBookAbstractCell >> notebook: anObject [

	notebook := anObject
]

{ #category : #accessing }
MiNoteBookAbstractCell >> previewCell [

	^ previewCell
]

{ #category : #accessing }
MiNoteBookAbstractCell >> previewCell: anObject [

	previewCell := anObject
]

{ #category : #initialization }
MiNoteBookAbstractCell >> remove [

	notebook removeCell: self
]

{ #category : #initialization }
MiNoteBookAbstractCell >> select [

	self takeKeyboardFocus.
	leftMenuCanvas canvas color: self selectedColor.
	leftMenuCanvas canvas signalUpdate.
	rightMenuCanvas canvas color: self selectedColor.
	rightMenuCanvas canvas signalUpdate
]

{ #category : #actions }
MiNoteBookAbstractCell >> selectAndScrollToMe [

	notebook selectAndScrollTo: self
]

{ #category : #actions }
MiNoteBookAbstractCell >> selectMe [

	notebook select: self.
	previewCell ifNotNil: [ :c | c selectAndScrollToMe ]
]

{ #category : #initialization }
MiNoteBookAbstractCell >> selectedColor [

	^ Color fromHexString: '77A8C8'
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
MiNoteBookAbstractCell >> unselect [

	self beUnselected
]

{ #category : #initialization }
MiNoteBookAbstractCell >> unselectedColor [

	^ Color transparent
]

{ #category : #initialization }
MiNoteBookAbstractCell >> updateHeight [

	UIManager default defer: [ 
		notebook headerSep withAdapterDo: [ :a | 
			cell withAdapterDo: [ :b | 
				| textMorph height width |
				textMorph := b widget.
				textMorph
					borderColor: Color gray translucent;
					borderWidth: 1.
				textMorph scrollPane
					vHideScrollbar;
					vScrollbarShowNever.
				width := a widget width.
				textMorph scrollPane textArea withoutSelectionBar.
				height := (RubEditingArea new
					           font: textMorph font;
					           width: width - 182;
					           beWrapped;
					           updateTextWith: cell text) height.
				self withAdapterDo: [ :c | c widget height: height + 2 ] ] ] ]
]

{ #category : #enumerating }
MiNoteBookAbstractCell >> whenTextChangedDo: aBlock [

	cell whenTextChangedDo: aBlock
]
