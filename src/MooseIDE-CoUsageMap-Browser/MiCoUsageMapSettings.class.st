"
todo
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #MiPresenter,
	#instVars : [
		'childrenTextInput'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #initialization }
MiCoUsageMapSettings >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: 'Children block: ' asPresenter expand: false;
			 add: childrenTextInput;
			 yourself)
]

{ #category : #initialization }
MiCoUsageMapSettings >> initializePresenters [

	childrenTextInput := self newCode
		                     withoutLineNumbers;
		                     text: '[ :container | container attributes]';
		                     yourself.
	self initializeLayout
]
