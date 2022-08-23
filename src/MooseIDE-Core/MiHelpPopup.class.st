Class {
	#name : #MiHelpPopup,
	#superclass : #MiPresenter,
	#instVars : [
		'help',
		'okButton',
		'browser'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiHelpPopup class >> defaultLayout [
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

{ #category : #api }
MiHelpPopup >> dismiss [
	self owner dismiss
]

{ #category : #initialization }
MiHelpPopup >> initializePresenters [
	super initializePresenters.
	help := self newText text: browser class comment.
	okButton := self newButton
		label: 'Ok';
		action: [ self owner dismiss ];
		yourself
]

{ #category : #'accessing - model' }
MiHelpPopup >> setModelBeforeInitialization: aBrowser [
	browser := aBrowser
]
