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
	#name : #MiQueryCodePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #specs }
MiQueryCodePresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #code;
		  yourself
]

{ #category : #action }
MiQueryCodePresenter >> acceptQueryCode: aCode [

	| query |
	query := [ FQAbstractQuery readFrom: aCode ]
		         on: Error
		         do: [ 
			         self informWrongCode.
			         ^ self ].
	(query isNil or: [ query isClass ]) ifFalse: [ self informWrongCode ]
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
MiQueryCodePresenter >> initializeCode [

	code := self newCode
		        withoutSyntaxHighlight;
		        beNotEditable;
		        text: self defaultComment;
		        whenSubmitDo: [ :text | self acceptQueryCode: text ];
		        yourself
]

{ #category : #initialization }
MiQueryCodePresenter >> initializePresenters [

	self initializeCode
]

{ #category : #'as yet unclassified' }
MiQueryCodePresenter >> text [

	self flag: 'Do not use this accessor. This is only for the tests'.
	^ code text
]

{ #category : #initialization }
MiQueryCodePresenter >> updateForQuery: aQuery [

	code text: (aQuery isRootQuery
			 ifTrue: [ self defaultComment ]
			 ifFalse: [ 
				 | parsedExpression |
				 parsedExpression := RBParser parseExpression:
					                     (String streamContents: [ :aStream | 
						                      aQuery
							                      storeOn: aStream
							                      withParentsIn: aQuery parentSequence ]).

				 parsedExpression formattedCode ])
]
