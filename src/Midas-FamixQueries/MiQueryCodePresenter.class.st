Class {
	#name : #MiQueryCodePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code',
		'modifyButton',
		'createButton',
		'isCreating'
	],
	#category : #'Midas-FamixQueries-Widgets'
}

{ #category : #specs }
MiQueryCodePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #modifyButton;
				add: #createButton;
				yourself)
			height: self buttonHeight;
		add: #code;
		yourself
]

{ #category : #action }
MiQueryCodePresenter >> acceptQueryCode: aCode [
	| query |
	query := FQAbstractQuery readFrom: aCode.
	isCreating
		ifTrue: [ self createNewQuery: query ]
		ifFalse: [ self modifyQuery: query ]
]

{ #category : #state }
MiQueryCodePresenter >> beCreating [
	isCreating := true
]

{ #category : #state }
MiQueryCodePresenter >> beModifying [
	isCreating := false
]

{ #category : #action }
MiQueryCodePresenter >> createNewQuery: aQuery [
	aQuery beChildOf: owner selectedQuery.
	owner updateForQuery: aQuery
]

{ #category : #initialization }
MiQueryCodePresenter >> initialize [
	self beCreating.
	super initialize
]

{ #category : #initialization }
MiQueryCodePresenter >> initializePresenters [
	super initializePresenters.
	self initializeRadioButtons.
	code := self newCode
		withoutSyntaxHighlight;
		whenSubmitDo: [ :text | self acceptQueryCode: text ];
		yourself
]

{ #category : #initialization }
MiQueryCodePresenter >> initializeRadioButtons [
	modifyButton := self newRadioButton
		label: 'Modify current query';
		whenActivatedDo: [ self beModifying ].
	createButton := self newRadioButton
		label: 'Create query';
		whenActivatedDo: [ self beCreating ].
	createButton associatedRadioButtons: {modifyButton}
]

{ #category : #action }
MiQueryCodePresenter >> modifyQuery: aQuery [
	self inform: 'Modifying a query is not working yet'
]

{ #category : #initialization }
MiQueryCodePresenter >> text: aText [
	code text: aText
]
