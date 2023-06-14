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

	^ self subclassResponsibility
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> innerQuery [

	^ innerQuery
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> innerQuery: anObject [

	innerQuery := anObject
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOn: aGroupOfEntities [
	"Runs the query on the input group of entities and returns the entities validating the query"

	self subclassResponsibility
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnCollection: aCollection [

	^ aCollection select: [ :each |
		  [ self runOn: each ] onErrorDo: [ :err |
			  err class = MessageNotUnderstood
				  ifTrue: [ false ]
				  ifFalse: [ self error: err ] ] ]
]
