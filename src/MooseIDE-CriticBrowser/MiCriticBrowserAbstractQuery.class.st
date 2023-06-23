"
An abstract class to represent the query side of the model critic browser.
"
Class {
	#name : #MiCriticBrowserAbstractQuery,
	#superclass : #Object,
	#instVars : [
		'innerQuery'
	],
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #'instance creation' }
MiCriticBrowserAbstractQuery class >> on: aQuery [

	^ self new
		  innerQuery: aQuery;
		  yourself
]

{ #category : #converting }
MiCriticBrowserAbstractQuery >> convertToSTONString [
	"Converts the query to a string used to save the query in STON format.
	The string must return the query when evaluated by the Smalltalk compiler"

	^ String streamContents: [ :stream |
		  innerQuery storeWithParentsOn: stream ]
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> innerQuery [

	^ innerQuery
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> innerQuery: anObject [

	innerQuery := anObject isString
		              ifTrue: [
		              FQSelectScriptQuery script: anObject asValuable ]
		              ifFalse: [ anObject ]
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOn: aGroupOfEntities [
	"Runs the query on the input group of entities and returns the entities validating the query"

	self subclassResponsibility
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnCollection: aCollection [

	^ innerQuery isUnaryQuery
		  ifTrue: [ self runOnUnaryQuery: aCollection ]
		  ifFalse: [ self runOnNAryQuery: aCollection ]
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnNAryQuery: aCollection [

	^ innerQuery runOn: (innerQuery subqueries collect: [ :subQuery |
			   (self class on: subQuery) runOnCollection: aCollection ])
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnQueryWithParent: aCollection [

	^ innerQuery runOn:
		  ((self class on: innerQuery parent) runOnCollection: aCollection)
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnUnaryQuery: aCollection [

	^ (innerQuery parent isNil or: [ innerQuery parent isRootQuery ])
		  ifTrue: [ innerQuery runOn: aCollection ]
		  ifFalse: [ self runOnQueryWithParent: aCollection ]
]
