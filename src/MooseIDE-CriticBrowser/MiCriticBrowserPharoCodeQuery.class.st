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
	"Converts the query to a string used to save the query in STON format.
	The string must return the query when evaluated by the Smalltalk compiler"

	^ innerQuery asString
]

{ #category : #accessing }
MiCriticBrowserPharoCodeQuery >> innerQuery: aString [

	innerQuery := self stringToFullBlockClosure: aString
]

{ #category : #running }
MiCriticBrowserPharoCodeQuery >> runOn: anEntity [
	"Runs the query on the input group of entities and returns the entities validating the query"

	^ innerQuery value: anEntity
]

{ #category : #converting }
MiCriticBrowserPharoCodeQuery >> stringToFullBlockClosure: aString [
	"Converts a string to a block (to run the query)"

	^ Smalltalk compiler evaluate: aString
]
