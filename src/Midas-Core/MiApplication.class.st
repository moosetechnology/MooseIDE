Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'logger',
		'name'
	],
	#classVars : [
		'Current',
		'Registry'
	],
	#category : #'Midas-Core-Application'
}

{ #category : #accessing }
MiApplication class >> default [
	^ self named: 'Default'
]

{ #category : #accessing }
MiApplication class >> deleteApplication: anApplication [
	self registry remove: anApplication ifAbsent: [  ]
]

{ #category : #accessing }
MiApplication class >> deleteApplicationNamed: aName [
	self registry remove: (self named: aName)
]

{ #category : #accessing }
MiApplication class >> named: aName [
	^ self registry
		detect: [ :app | app name = aName ]
		ifNone: [ self registry
				add:
					(self new
						name: aName;
						yourself) ]
]

{ #category : #registry }
MiApplication class >> registry [
	^ Registry ifNil: [ Registry := Set new ]
]

{ #category : #accessing }
MiApplication class >> reset [
	<script>
	self flag: 'Dangerous if some browsers still use custom applications'.
	Registry := Set new
]

{ #category : #accessing }
MiApplication >> browsers [
	^ self windows collect: #presenter thenSelect: #isMiBrowser
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

{ #category : #accessing }
MiApplication >> name [
	^ name
]

{ #category : #accessing }
MiApplication >> name: anObject [
	name := anObject
]

{ #category : #actions }
MiApplication >> refreshBrowsersWith: anEntity [
	self browsers do: [ :browser | browser selectEntity: anEntity ]
]

{ #category : #actions }
MiApplication >> start [
	"we will see"
]
