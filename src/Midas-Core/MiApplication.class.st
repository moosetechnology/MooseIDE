Class {
	#name : #MiApplication,
	#superclass : #SpApplication,
	#instVars : [
		'buses'
	],
	#classVars : [
		'Current'
	],
	#category : #'Midas-Core-Application'
}

{ #category : #'instance creation' }
MiApplication class >> current [
	^ Current ifNil: [ Current := self new ]
]

{ #category : #accessing }
MiApplication class >> defaultBusName [
	^ 'Default'
]

{ #category : #'instance creation' }
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
	^ self busNamed: self class defaultBusName
]

{ #category : #buses }
MiApplication >> deleteBus: aBus [
	aBus isDefault
		ifFalse: [ buses remove: aBus ifAbsent: [  ] ]
]

{ #category : #buses }
MiApplication >> deleteBusNamed: aName [
	buses
		detect: [ :bus | bus name = aName ]
		ifFound: [ :bus | self deleteBus: bus ]
]

{ #category : #initialization }
MiApplication >> initialize [
	super initialize.
	buses := Set new
		add: (MiBus named: self class defaultBusName);
		yourself
]

{ #category : #actions }
MiApplication >> start [
	"we will see"
]
