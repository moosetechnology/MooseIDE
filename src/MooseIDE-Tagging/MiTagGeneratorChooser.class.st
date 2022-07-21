Class {
	#name : #MiTagGeneratorChooser,
	#superclass : #MiPresenter,
	#instVars : [
		'nextButton',
		'chooserItems'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagGeneratorChooser class >> title [

	^ 'Choose generation items'
]

{ #category : #layout }
MiTagGeneratorChooser >> defaultLayout [

	^ SpBoxLayout newTopToBottom 
			add: chooserItems;
			spacing: 5; 
			add: (SpBoxLayout newLeftToRight
					  addLast: nextButton;
					  yourself)
			expand: false;
			yourself
]

{ #category : #accessing }
MiTagGeneratorChooser >> defaultTitle [
	^ self class title
]

{ #category : #layout }
MiTagGeneratorChooser >> initializePresenters [

	super initializePresenters.
	chooserItems := self setChooserItems.
	nextButton := self newButton.
	nextButton
		label: 'Next';
		icon: (self iconNamed: #smallOk)
]

{ #category : #initialization }
MiTagGeneratorChooser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 450 @ 360
]

{ #category : #initialization }
MiTagGeneratorChooser >> setChooserItems [

	| chooser |
	chooser := SpChooserPresenter
		           sourceItems: {  }
		           chosenItems: {  }
		           displayBlock: [ :each | each name ].
	^ chooser
]
