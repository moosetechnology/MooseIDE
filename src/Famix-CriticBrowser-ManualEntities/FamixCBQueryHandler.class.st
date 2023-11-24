"
An abstract class to represent the query side of the model critic browser.
"
Class {
	#name : #FamixCBQueryHandler,
	#superclass : #Object,
	#instVars : [
		'innerQuery'
	],
	#category : #'Famix-CriticBrowser-ManualEntities-QueryHandler'
}

{ #category : #'instance creation' }
FamixCBQueryHandler class >> on: aQuery [

	^ self new
		  innerQuery: aQuery;
		  yourself
]

{ #category : #converting }
FamixCBQueryHandler >> asRuleEditorString [
	^ innerQuery script asString
]

{ #category : #converting }
FamixCBQueryHandler >> convertToSTONString [

	"Converts the query to a string used to save the query in STON format.
	The string must return the query when evaluated by the Smalltalk compiler"

	^ String streamContents: [ :stream | 
		  innerQuery storeWithParentsOn: stream ]
]

{ #category : #accessing }
FamixCBQueryHandler >> innerQuery [

	^ innerQuery
]

{ #category : #accessing }
FamixCBQueryHandler >> innerQuery: anObject [

	innerQuery := anObject
]

{ #category : #running }
FamixCBQueryHandler >> runOnCollection: aCollection [

	^ innerQuery isUnaryQuery
		  ifTrue: [ self runOnUnaryQuery: aCollection ]
		  ifFalse: [ self runOnNAryQuery: aCollection ]
]

{ #category : #running }
FamixCBQueryHandler >> runOnNAryQuery: aCollection [

	^ innerQuery runOn: (innerQuery subqueries collect: [ :subQuery |
			   (self class on: subQuery) runOnCollection: aCollection ])
]

{ #category : #running }
FamixCBQueryHandler >> runOnQueryWithParent: aCollection [

	^ innerQuery runOn:
		  ((self class on: innerQuery parent) runOnCollection: aCollection)
]

{ #category : #running }
FamixCBQueryHandler >> runOnUnaryQuery: aCollection [

	^ (innerQuery parent isNil or: [ innerQuery parent isRootQuery ])
		  ifTrue: [ innerQuery runOn: aCollection ]
		  ifFalse: [ self runOnQueryWithParent: aCollection ]
]
