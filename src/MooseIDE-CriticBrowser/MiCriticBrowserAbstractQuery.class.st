"
An abstract class to represent the query side of the model critic browser.
"
Class {
	#name : #MiCriticBrowserAbstractQuery,
	#superclass : #Object,
	#instVars : [
		'query'
	],
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #'instance creation' }
MiCriticBrowserAbstractQuery class >> on: aQuery [
	^self new
		query: aQuery ;
		yourself
]

{ #category : #converting }
MiCriticBrowserAbstractQuery >> convertToSTONString [
"converts the query to a string used to save the query in STON format, the string must return the query when evaluated by the Smalltalk compiler"
	^ self subclassResponsibility
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> query [

	^ query
]

{ #category : #accessing }
MiCriticBrowserAbstractQuery >> query: anObject [

	query := anObject
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOn: aGroupOfEntities [
"runs the query on the input group of entities, and returns the entities validating the query"
	self subclassResponsibility  
]

{ #category : #running }
MiCriticBrowserAbstractQuery >> runOnCollection: aCollection [
	^ aCollection select: [ :each | [ self runOn: each ] 
		onErrorDo: [ :err | (err class = MessageNotUnderstood) 
			ifTrue: [ false ] 
			ifFalse: [ self error: err ] 
		] ]
	
]
