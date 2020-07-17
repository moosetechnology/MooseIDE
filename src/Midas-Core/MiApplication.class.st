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
		detect: [ :b | b name = aName ]
		ifNone: [ | bus |
			bus := MiBus named: aName.
			buses add: bus.
			self updateOverviewBrowsers.
			bus ]
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
		ifTrue: [ ^ self ].
	buses remove: aBus ifAbsent: [  ].
	self updateOverviewBrowsers
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
	buses := OrderedCollection new
		add: (MiBus named: self class defaultBusName);
		yourself
]

{ #category : #'private showing' }
MiApplication >> open: aPresenter withSpecLayout: aSpecLayout using: aWindowClass [
	super
		open: aPresenter
		withSpecLayout: aSpecLayout
		using: aWindowClass.
	self updateOverviewBrowsers
]

{ #category : #actions }
MiApplication >> start [
	"we will see"
]

{ #category : #actions }
MiApplication >> updateLogBrowsers [
	self flag: 'To remove ?'.
	self browsers
		select: [ :browser | browser class == MiLogBrowser ]
		thenDo: [ :logBrowser | 
			self buses do: [ :bus | logBrowser followBus: bus ].
			logBrowser update ]
]

{ #category : #actions }
MiApplication >> updateOverviewBrowsers [
	(self windows
		collect: #presenter
		thenSelect: [ :presenter | presenter class == MiOverviewBrowser ])
		do: #update
]
