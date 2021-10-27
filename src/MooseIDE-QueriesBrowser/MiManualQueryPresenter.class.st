"
I am a presenter that compiles a query according to a code input
"
Class {
	#name : #MiManualQueryPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'writeQueryButton',
		'parentQuery',
		'query'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #initialization }
MiManualQueryPresenter >> initializeButton [

	writeQueryButton := self newButton.
	writeQueryButton
		label: 'Code a query';
		icon: (self iconNamed: #edit);
		action: [  ]
]

{ #category : #initialization }
MiManualQueryPresenter >> initializeLayout [

	self layout: self newLayout
]

{ #category : #initialization }
MiManualQueryPresenter >> initializePresenters [
 
	self initializeButton.
	self initializeLayout
]

{ #category : #testing }
MiManualQueryPresenter >> isQueryUsed: aQuery [

	^ false
]

{ #category : #layout }
MiManualQueryPresenter >> newLayout [

	| label |
	label := self newLabel label: 'Manual Query     '.

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		add: label expand: false;
		add: writeQueryButton expand: false;
		yourself
]

{ #category : #transmissions }
MiManualQueryPresenter >> notifyQueryChanged [

	owner queryChangedUpdate
]

{ #category : #accessing }
MiManualQueryPresenter >> query [

	^ query ifNil: [ parentQuery ]
]

{ #category : #'api - actions' }
MiManualQueryPresenter >> queryPresentersListChanged [
]

{ #category : #'accessing - model' }
MiManualQueryPresenter >> setModelBeforeInitialization: aParentQuery [

	parentQuery := aParentQuery
]
