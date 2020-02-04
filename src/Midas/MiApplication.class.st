Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'logger'
	],
	#classVars : [
		'Current'
	],
	#category : #'Midas-Application'
}

{ #category : #accessing }
MiApplication class >> current [
	^ Current ifNil: [ Current := self new ]
]

{ #category : #accessing }
MiApplication class >> reset [
	<script>
	Current := nil
]

{ #category : #documentation }
MiApplication >> browsers [
	^ self windows collect: #presenter thenSelect: #isMiBrowser
]

{ #category : #documentation }
MiApplication >> globallySelect: anEntity [
	self logger globallySelect: anEntity
]

{ #category : #documentation }
MiApplication >> initialize [
	super initialize.
	self logger: MiLogger new
]

{ #category : #documentation }
MiApplication >> logger [
	^ logger
]

{ #category : #documentation }
MiApplication >> logger: anObject [
	logger := anObject.
	logger application: self
]

{ #category : #documentation }
MiApplication >> refreshBrowsersWith: anEntity [
	self browsers do: [ :browser | browser selectEntity: anEntity ]
]

{ #category : #documentation }
MiApplication >> start [
	"we will see"
]
