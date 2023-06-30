"
An abstract class to represent the query side of the model critic browser.
"
Class {
	#name : #MiCBQueryHandler,
	#superclass : #Object,
	#instVars : [
		'innerQuery'
	],
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #'instance creation' }
MiCBQueryHandler class >> on: aQuery [

	^ self new
		  innerQuery: aQuery;
		  yourself
]

{ #category : #converting }
MiCBQueryHandler >> asRuleEditorString [

	^ '[ :entity | entity ]'
]

{ #category : #converting }
MiCBQueryHandler >> convertToSTONString [
	"Converts the query to a string used to save the query in STON format.
	The string must return the query when evaluated by the Smalltalk compiler"

	^ String streamContents: [ :stream |
		  innerQuery storeWithParentsOn: stream ]
]

{ #category : #accessing }
MiCBQueryHandler >> innerQuery [

	^ innerQuery
]

{ #category : #accessing }
MiCBQueryHandler >> innerQuery: anObject [

	innerQuery := anObject
]

{ #category : #running }
MiCBQueryHandler >> runOnCollection: aCollection [

	^ innerQuery isUnaryQuery
		  ifTrue: [ self runOnUnaryQuery: aCollection ]
		  ifFalse: [ self runOnNAryQuery: aCollection ]
]

{ #category : #running }
MiCBQueryHandler >> runOnNAryQuery: aCollection [

	^ innerQuery runOn: (innerQuery subqueries collect: [ :subQuery |
			   (self class on: subQuery) runOnCollection: aCollection ])
]

{ #category : #running }
MiCBQueryHandler >> runOnQueryWithParent: aCollection [

	^ innerQuery runOn:
		  ((self class on: innerQuery parent) runOnCollection: aCollection)
]

{ #category : #running }
MiCBQueryHandler >> runOnUnaryQuery: aCollection [

	^ (innerQuery parent isNil or: [ innerQuery parent isRootQuery ])
		  ifTrue: [ innerQuery runOn: aCollection ]
		  ifFalse: [ self runOnQueryWithParent: aCollection ]
]
