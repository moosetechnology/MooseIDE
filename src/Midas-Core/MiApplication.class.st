Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'logger',
		'buses'
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

{ #category : #accessing }
MiApplication >> browsers [
	^ self windows collect: #presenter thenSelect: #isMiBrowser
]

{ #category : #buses }
MiApplication >> busNamed: aName [
	^ buses
		detect: [ :bus | bus name = aName ]
		ifNone: [ buses add: (MiBus named: aName) ]
]

{ #category : #accessing }
MiApplication >> buses [
	^ buses
]

{ #category : #buses }
MiApplication >> defaultBus [
	^ self busNamed: 'Default'
]

{ #category : #buses }
MiApplication >> deleteBus: aBus [
	buses remove: aBus ifAbsent: [  ]
]

{ #category : #buses }
MiApplication >> deleteBusNamed: aName [
	buses remove: (self busNamed: aName)
]

{ #category : #actions }
MiApplication >> freezeBrowsersDuring: aBlock [
	| activeButtons |
	activeButtons := self browsers
		collect: [ :browser | browser activeStateButton ].
	self browsers do: [ :browser | browser freeze: true ].
	aBlock
		ensure: [ activeButtons do: [ :button | button state: true ] ]
]

{ #category : #actions }
MiApplication >> globallySelect: anEntity [
	anEntity
		ifNotNil: [ (self logger newLogFor: anEntity) activateIn: self ]
]

{ #category : #initialization }
MiApplication >> initialize [
	super initialize.
	buses := Set new.
	self logger: MiLogger new
]

{ #category : #accessing }
MiApplication >> logger [
	^ logger
]

{ #category : #accessing }
MiApplication >> logger: anObject [
	logger := anObject
]

{ #category : #actions }
MiApplication >> refreshBrowsersWith: anEntity [
	self browsers do: [ :browser | browser selectEntity: anEntity ]
]

{ #category : #actions }
MiApplication >> start [
	"we will see"
]
