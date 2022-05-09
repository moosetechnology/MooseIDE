Class {
	#name : #MiButterflyMapSettings,
	#superclass : #MiPresenter,
	#instVars : [
		'submitButton',
		'childrenQueryDropList',
		'closeButton',
		'childrenBlockCode'
	],
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #initialization }
MiButterflyMapSettings >> connectPresenters [

	submitButton action: [ self submit ].
	closeButton action: [ self owner closeSettings ]
]

{ #category : #brokerage }
MiButterflyMapSettings >> consume: aQuery [

	self updateQueryList
]

{ #category : #initialization }
MiButterflyMapSettings >> fetchQueries [

	^ (self root application itemsFor: FQAbstractQuery) asOrderedCollection
]

{ #category : #initialization }
MiButterflyMapSettings >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: childrenQueryDropList;
			 add: childrenBlockCode;
			 add: submitButton;
			 add: closeButton;
			 yourself)
]

{ #category : #initialization }
MiButterflyMapSettings >> initializePresenters [

	submitButton := self newButton
		                label: 'Ok';
		                yourself.
	closeButton := self newButton
		               label: 'Cancel';
		               yourself.
	childrenQueryDropList := self newDropList.
	self updateQueryList.
	childrenBlockCode := self newCode.
	self initializeLayout
]

{ #category : #brokerage }
MiButterflyMapSettings >> remove: aQuery [

	self updateQueryList
]

{ #category : #initialization }
MiButterflyMapSettings >> submit [

	
]

{ #category : #brokerage }
MiButterflyMapSettings >> update: aQuery [

	self updateQueryList
]

{ #category : #initialization }
MiButterflyMapSettings >> updateQueryList [

	childrenQueryDropList items: self fetchQueries
]
