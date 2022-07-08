"
I am a handler for queries written in Pharo code, meant to be used by a rule in the Critic Browser.
"
Class {
	#name : #MiCriticBrowserPharoCodeQuery,
	#superclass : #MiCriticBrowserAbstractQuery,
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #converting }
MiCriticBrowserPharoCodeQuery >> convertToSTONString [
"converts the query to a string used to save the query in STON format, the string must return the query when evaluated by the Smalltalk compiler"
	^ query asString
]

{ #category : #accessing }
MiCriticBrowserPharoCodeQuery >> query: aString [
	query := self stringToFullBlockClosure: aString
]

{ #category : #running }
MiCriticBrowserPharoCodeQuery >> runOn: anEntity [
"runs the query on the input group of entities, and returns the entities validating the query"
	^ query value: anEntity 
]

{ #category : #converting }
MiCriticBrowserPharoCodeQuery >> stringToFullBlockClosure: aString [
"converts a string to an block (to run the query)"
	^ Smalltalk compiler evaluate: aString
]
