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
	query := [ FQAbstractQuery readFrom: aCode ]
		on: Error
		do: [ self informWrongCode.
			^ self ].
	(query isNil or: [ query isClass ])
		ifTrue: [ self informWrongCode.
			^ self ].
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
MiQueryCodePresenter >> defaultComment [
	^ '"Query code"'
]

{ #category : #action }
MiQueryCodePresenter >> informWrongCode [
	UIManager default
		inform:
			'This code does not build a query. 
Click to get current query code.'
		actionOnClick: [ code
				text: (String streamContents: [ :s | owner selectedQuery storeOn: s ]) ]
]

{ #category : #initialization }
MiQueryCodePresenter >> initialize [
	self beCreating.
	super initialize
]

{ #category : #initialization }
MiQueryCodePresenter >> initializeCode [
	code := self newCode
		withoutSyntaxHighlight;
		text: self defaultComment;
		whenSubmitDo: [ :text | self acceptQueryCode: text ];
		yourself
]

{ #category : #initialization }
MiQueryCodePresenter >> initializePresenters [
	super initializePresenters.
	self initializeRadioButtons.
	self initializeCode
]

{ #category : #initialization }
MiQueryCodePresenter >> initializeRadioButtons [
	modifyButton := self newRadioButton
		enabled: owner selectedQuery isRootQuery not;
		label: 'Modify current query';
		whenActivatedDo: [ self beModifying ].
	createButton := self newRadioButton
		label: 'Create query';
		whenActivatedDo: [ self beCreating ].
	createButton associatedRadioButtons: {modifyButton}
]

{ #category : #action }
MiQueryCodePresenter >> modifyQuery: aQuery [
	owner replaceSelectedQueryWith: aQuery
]

{ #category : #initialization }
MiQueryCodePresenter >> updateForQuery: aQuery [
	modifyButton enabled: aQuery isRootQuery not.
	createButton state: aQuery isRootQuery.
	code
		text:
			(aQuery isRootQuery
				ifTrue: [ self defaultComment ]
				ifFalse: [ EFFormatter
						format:
							(RBParser
								parseExpression: (String streamContents: [ :s | aQuery storeOn: s ])) ])
]
