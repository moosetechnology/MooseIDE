"
I am a handler for queries coming from the MooseIDE Queries Browser, meant to be used by a rule in the Critic Browser.
"
Class {
	#name : #MiCriticBrowserFQQuery,
	#superclass : #MiCriticBrowserAbstractQuery,
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #converting }
MiCriticBrowserFQQuery >> convertToSTONString [
	"Converts the query to a string used to save the query in STON format.
	The string must return the query when evaluated by the Smalltalk compiler"

	| stream |
	stream := String new writeStream.
	innerQuery storeWithParentsOn: stream.
	^ stream contents
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOn: aGroupOfEntities [
	"Runs the query on the input group of entities and returns the entities validating the query"

	^ nil
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOnCollection: aCollection [

	^ (innerQuery class inheritsFromOrEqualTo: FQNAryQuery)
		  ifTrue: [ self runOnNAryQuery: aCollection ]
		  ifFalse: [
			  (innerQuery parent class = FQRootQuery or: [ innerQuery parent isNil ])
				  ifTrue: [ innerQuery runOn: aCollection ]
				  ifFalse: [ self runOnQueryWithParent: aCollection ] ]
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOnNAryQuery: aCollection [

	| queries |
	queries := innerQuery subqueries collect: [ :sq | self class on: sq ].
	^ innerQuery runOn:
		  (queries collect: [ :q | q runOnCollection: aCollection ])
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOnQueryWithParent: aCollection [

	| parentQuery |
	parentQuery := self class on: innerQuery parent.
	^ innerQuery runOn: (parentQuery runOnCollection: aCollection)
]
