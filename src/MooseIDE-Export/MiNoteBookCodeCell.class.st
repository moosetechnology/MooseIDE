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
		        icon: (MiApplication current iconNamed: #mooseEvaluator);
		        action: [ notebook transformToTextCell: self ].
	self initializeLayout
]
