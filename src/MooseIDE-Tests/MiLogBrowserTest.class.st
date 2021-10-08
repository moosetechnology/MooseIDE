Class {
	#name : #MiLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect',
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiLogBrowserTest >> browserClass [
	^ MiLogBrowser
]

{ #category : #initialization }
MiLogBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #running }
MiLogBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testBusList [

	self assert: browser logsList size equals: 1.
	self assert: browser logsList first bus equals: self bus
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testBusListWhenFollowingTwoBuses [

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.
	browser followBus: otherBus.

	self assert: browser logsList size equals: 2.
	self assert: ((browser logsList collect: #bus) includes: otherBus)
]

{ #category : #tests }
MiLogBrowserTest >> testMiSelectedItem [

	self bus globallySelect: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testOpenOnAllBuses [

	"Show all buses, do not select any entity"

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.

	otherBus globallySelect: entityToSelect.
	self bus globallySelect: entityToSelect.

	newBrowser := self browserClass openForTests.

	newBrowser logsList do: [ :busLogsList | 
		self assert: busLogsList miSelectedItem isNil ]
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testOpenOnOneBus [

	"Show 1 buses, select latest entity"

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.

	otherBus globallySelect: entityToSelect.
	self bus globallySelect: entityToSelect.

	newBrowser := self browserClass openForTestsOnBus: otherBus.

	self
		assert: newBrowser logsList anyOne miSelectedItem
		equals: entityToSelect
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testSelectedItemWhenFollowingTwoBuses [

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.
	browser followBus: otherBus.

	otherBus globallySelect: entityToSelect.
	self
		assert:
			(browser logsList detect: [ :busLogsList | 
				 busLogsList bus = otherBus ]) miSelectedItem
		equals: entityToSelect.

	self bus globallySelect: entityToSelect.
	self
		assert:
			(browser logsList detect: [ :busLogsList | 
				 busLogsList bus = self bus ]) miSelectedItem
		equals: entityToSelect.
	self assert:
		(browser logsList detect: [ :busLogsList | 
			 busLogsList bus = otherBus ]) miSelectedItem isNil
]
