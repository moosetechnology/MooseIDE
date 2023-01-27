"
I am a code cell presenter. I allow user to code with the bindings given by the browser.
"
Class {
	#name : #MiNoteBookCodeCell,
	#superclass : #MiNoteBookAbstractCell,
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #converting }
MiNoteBookCodeCell >> asModelCell [

	^ MiNoteBookCodeCellModel new
		  text: cell text;
		  yourself
]

{ #category : #api }
MiNoteBookCodeCell >> beCode [

	^ self
]

{ #category : #api }
MiNoteBookCodeCell >> beText [

	notebook transformToTextCell: self
]

{ #category : #initialization }
MiNoteBookCodeCell >> initializePresenters [

	super initializePresenters.
	cell := self newCode
		        withoutLineNumbers;
		        beForScripting;
		        placeholder: 'Binded variables: mooseModel, printer, stream';
		        yourself.
	cell whenTextChangedDo: [ self updateHeight ].
	icon := self newButton
		        label: 'Code';
		        action: [ notebook transformToTextCell: self ].

	leftMenuCanvas canvas
		add: (RSLabel new
				 text: '[ ]';
				 bold;
				 color: Color black;
				 yourself);
		when: RSMouseClick do: [ notebook transformToTextCell: self ].
	self initializeLayout
]

{ #category : #api }
MiNoteBookCodeCell >> interactionModel: anEnvironment [

	cell interactionModel: anEnvironment
]

{ #category : #accessing }
MiNoteBookCodeCell >> notebook: aNoteBook [

	notebook := aNoteBook.
	self interactionModel: notebook interactionModel
]
