Class {
	#name : #MiHelpPopup,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'help',
		'okButton'
	],
	#category : #'Midas-Core-Browser'
}

{ #category : #specs }
MiHelpPopup class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		borderWidth: 5;
		add:
			(SpBoxLayout newVertical
				spacing: 5;
				add: #help height: 250;
				add: #okButton height: self buttonHeight;
				yourself)
			width: 250;
		yourself
]

{ #category : #initialization }
MiHelpPopup >> initializePresenters [
	super initializePresenters.
	help := self newText text: model class comment.
	okButton := self newButton
		label: 'Ok';
		action: [ self owner dismiss ];
		yourself
]

{ #category : #initialization }
MiHelpPopup >> setModelBeforeInitialization: aBrowser [
	model := aBrowser
]
