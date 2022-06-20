"
I am a handler for queries coming from the MooseIDE Queries Browser, meant to be used by a rule in the Critic Browser.
"
Class {
	#name : #MiCriticBrowserFQQuery,
	#superclass : #MiCriticBrowserAbstractQuery,
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #converting }
MiCriticBrowserFQQuery >> convertToSTONString [
"converts the query to a string used to save the query in STON format, the string must return the query when evaluated by the Smalltalk compiler"
	| stream |
	stream := (String new) writeStream.
	query storeWithParentsOn: stream.
	^ stream contents
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOn: aGroupOfEntities [
"runs the query on the input group of entities, and returns the entities validating the query"
	 ^ nil
]

{ #category : #running }
MiCriticBrowserFQQuery >> runOnCollection: aCollection [
	^ (query parent class = FQRootQuery or: [ query parent isNil ])
		ifTrue: [ query runOn: aCollection ]
		ifFalse: [ | parentQuery | parentQuery := self class on: query parent.
											query runOn: (parentQuery runOnCollection: aCollection) ]
]
