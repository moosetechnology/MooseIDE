Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'logger'
	],
	#classVars : [
		'Current'
	],
	#category : #'Midas-Core-Application'
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

{ #category : #'as yet unclassified' }
MiApplication >> freezeBrowsersDuring: aBlock [
	| activeButtons |
	activeButtons := self browsers
		collect: [ :browser | browser activeStateButton ].
	self browsers do: [ :browser | browser freeze: true ].
	aBlock
		ensure: [ activeButtons do: [ :button | button state: true ] ]
]

{ #category : #documentation }
MiApplication >> globallySelect: anEntity [
	anEntity ifNotNil: [ (self logger newLogFor: anEntity) activate ]
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
