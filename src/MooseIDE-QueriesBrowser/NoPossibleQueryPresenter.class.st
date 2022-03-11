"
I am a presenter that only shows the message 'No property available' when a invalid query is created in a `MiQueryConfigurationPresenter`
"
Class {
	#name : #NoPossibleQueryPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'textToDisplay',
		'label',
		'null1',
		'null2'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #initialization }
NoPossibleQueryPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal
			 add: (SpBoxLayout newVertical
					  add: null1;
					  add: label;
					  add: null2;
					  yourself)
			 width: 175;
			 yourself)
]

{ #category : #initialization }
NoPossibleQueryPresenter >> initializePresenters [

	label := self newLabel
		         label: textToDisplay;
		         yourself.
	null1 := self newNullPresenter.
	null2 := self newNullPresenter.
	self initializeLayout
]

{ #category : #testing }
NoPossibleQueryPresenter >> isImpossibleQueryPresenter [

	^ true
]

{ #category : #'accessing model' }
NoPossibleQueryPresenter >> setModelBeforeInitialization: aString [
	textToDisplay := 'No ' , aString , ' available'
]
