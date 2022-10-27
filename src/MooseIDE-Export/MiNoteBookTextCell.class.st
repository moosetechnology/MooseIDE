Class {
	#name : #MiNoteBookTextCell,
	#superclass : #MiNoteBookAbstractCell,
	#category : #'MooseIDE-Export-Report'
}

{ #category : #converting }
MiNoteBookTextCell >> asModelCell [

	^ MiNoteBookTextCellModel new
		  text: cell text;
		  yourself
]

{ #category : #api }
MiNoteBookTextCell >> beCode [

	notebook transformToCodeCell: self
]

{ #category : #api }
MiNoteBookTextCell >> beText [

	^ self
]

{ #category : #initialization }
MiNoteBookTextCell >> initializePresenters [

	super initializePresenters.
	cell := self newText.
	cell whenTextChangedDo: [ self updateHeight ].
	icon := self newButton
		        label: 'Mic';
		        action: [ notebook transformToCodeCell: self ];
		        yourself.
	leftMenuCanvas canvas add: (RSLabel new
			 text: 'Microdown';
			 color: Color black;
			 when: RSMouseClick do: [ notebook transformToCodeCell: self ];
			 yourself).
	self initializeLayout
]
