"
Abstract super class for the browsers receiving modes.
"
Class {
	#name : #MiBrowserReceivingMode,
	#superclass : #Object,
	#category : #'MooseIDE-Core-ReceivingMode'
}

{ #category : #action }
MiBrowserReceivingMode class >> browser: aBrowser actOnEntity: anEntity [

	self subclassResponsibility
]

{ #category : #'radio button' }
MiBrowserReceivingMode class >> buttonEnabledInBrowser: aBrowser [

	^ self subclassResponsibility
]

{ #category : #'radio button' }
MiBrowserReceivingMode class >> buttonLabel [

	^ self subclassResponsibility
]

{ #category : #'radio button' }
MiBrowserReceivingMode class >> newRadioButtonIn: aBrowser [

	"This should probably be the responsibility of a command.
However, as a command cannot be displayed as a radio button, let's keep it here for now."

	^ aBrowser newRadioButton
		  label: self buttonLabel;
		  enabled: (self buttonEnabledInBrowser: aBrowser);
		  whenActivatedDo: [ aBrowser receivingMode: self ]
]
