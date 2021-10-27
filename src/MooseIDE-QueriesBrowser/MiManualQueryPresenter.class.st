"
I am a presenter that compiles a query according to a code input
"
Class {
	#name : #MiManualQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'writeQueryButton',
		'parentQuery',
		'queryCoder'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #actions }
MiManualQueryPresenter >> computeQuery: anObject [

	
]

{ #category : #'api - actions' }
MiManualQueryPresenter >> configureFor: aQuery [

]

{ #category : #initialization }
MiManualQueryPresenter >> initialize [

	super initialize.
	query := FQNullQuery new
]

{ #category : #initialization }
MiManualQueryPresenter >> initializeButton [

	writeQueryButton := self newButton.
	writeQueryButton
		label: 'Code a query';
		icon: (self iconNamed: #edit);
		action: [ self openQueryCoderPopup ]
]

{ #category : #initialization }
MiManualQueryPresenter >> initializeLayout [

	self layout: self newLayout
]

{ #category : #initialization }
MiManualQueryPresenter >> initializePresenters [
 
	self initializeButton.
	self initializeQueryCoder.
	self initializeLayout
]

{ #category : #initialization }
MiManualQueryPresenter >> initializeQueryCoder [

	queryCoder := self instantiate: QueryCompilerPresenter new
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

{ #category : #actions }
MiManualQueryPresenter >> openQueryCoderPopup [

	self newPopover
		relativeTo: writeQueryButton;
		bePositionRight;
		presenter: queryCoder;
		popup
]

{ #category : #'accessing - model' }
MiManualQueryPresenter >> setModelBeforeInitialization: aParentQuery [

	parentQuery := aParentQuery
]
