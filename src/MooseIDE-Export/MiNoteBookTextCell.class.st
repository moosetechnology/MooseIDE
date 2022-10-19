Class {
	#name : #MiNoteBookTextCell,
	#superclass : #MiNoteBookAbstractCell,
	#category : #'MooseIDE-Export-Report'
}

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
		        icon: (MiApplication current iconNamed: #none);
		        action: [ notebook transformToCodeCell: self ];
		        yourself.
	self initializeLayout
]
