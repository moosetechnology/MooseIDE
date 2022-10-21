Class {
	#name : #MiNoteBookCodeCell,
	#superclass : #MiNoteBookAbstractCell,
	#category : #'MooseIDE-Export-Report'
}

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
		        yourself.
	cell whenTextChangedDo: [ self updateHeight ].
	icon := self newButton
		        label: 'St';
		        action: [ notebook transformToTextCell: self ].

	leftMenuCanvas canvas add: (RSLabel new
			 text: 'St';
			 color: Color black;
			 when: RSMouseClick do: [ notebook transformToTextCell: self ];
			 yourself).
	leftMenuCanvas canvas color: Color blue.
	self initializeLayout
]

{ #category : #api }
MiNoteBookCodeCell >> interactionModel: anEnvironment [

	cell interactionModel: anEnvironment
]
