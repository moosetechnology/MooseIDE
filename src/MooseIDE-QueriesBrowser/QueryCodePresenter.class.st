"
I am a presenter that I am used in the queries browser. I show as a string the code of the current selected query.
For example: 
```
FQTypeQuery types: { 
		FamixStLocalVariable.
		FamixStParameter.
		FamixStUnknownVariable }
```
"
Class {
	#name : #QueryCodePresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'code'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #action }
QueryCodePresenter >> acceptQueryCode: aCode [

	| query |
	query := [ FQAbstractQuery readFrom: aCode ]
		on: Error
		do: [ 
			self informWrongCode.
			^ self ].
	(query isNil or: [ query isClass ]) ifFalse: [ self informWrongCode ]
]

{ #category : #initialization }
QueryCodePresenter >> defaultComment [

	^ '"Query code"'
]

{ #category : #action }
QueryCodePresenter >> informWrongCode [

	| message |
	message := 'This code does not build a query. 
Click to get current query code.'.

	UIManager default
		inform: message
		actionOnClick: [ code text:
			(String streamContents: [ :s | owner selectedQuery storeOn: s ]) ]
]

{ #category : #initialization }
QueryCodePresenter >> initializeCode [

	code := self newCode
		withoutSyntaxHighlight;
		withoutLineNumbers;
		beNotEditable;
		text: self defaultComment;
		whenSubmitDo: [ :text | self acceptQueryCode: text ];
		yourself
]

{ #category : #initialization }
QueryCodePresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
		add: code;
		yourself)
]

{ #category : #initialization }
QueryCodePresenter >> initializePresenters [

	self initializeCode.
	self initializeLayout
]

{ #category : #initialization }
QueryCodePresenter >> updateForQuery: aQuery [

	| text |
	text := aQuery isRootQuery
		ifTrue: [ self defaultComment ]
		ifFalse: [ 
			| parsedExpression |
			parsedExpression := RBParser parseExpression:
				(String streamContents: [ :aStream | aQuery storeWithParentsOn: aStream ]).
			parsedExpression formattedCode ].

	code text: text
]
