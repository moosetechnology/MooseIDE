"
I am a presenter that only shows the message 'No property available' when a invalid query is created in a `MiQueryConfigurationPresenter`
"
Class {
	#name : #MiNoPossibleQueryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textToDisplay',
		'label',
		'null1',
		'null2'
	],
	#category : #'MooseIDE-NewTools-Queries Browser widgets'
}

{ #category : #specs }
MiNoPossibleQueryPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #null1;
				add: #label;
				add: #null2;
				yourself)
			width: 175;
		yourself
]

{ #category : #initialization }
MiNoPossibleQueryPresenter >> initializePresenters [
	label := self newLabel
		label: textToDisplay;
		yourself.
	null1 := self newNullPresenter.
	null2 := self newNullPresenter
]

{ #category : #testing }
MiNoPossibleQueryPresenter >> isImpossibleQueryPresenter [

	^ true
]

{ #category : #'accessing model' }
MiNoPossibleQueryPresenter >> setModelBeforeInitialization: aString [
	textToDisplay := 'No ' , aString , ' available'
]
