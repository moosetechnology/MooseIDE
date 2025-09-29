Class {
	#name : #MiApplicationTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'bus'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiApplicationTest >> alternativeBusName [

	^ 'TestBus2'
]

{ #category : #running }
MiApplicationTest >> busName [

	^ 'Not the default bus'
]

{ #category : #running }
MiApplicationTest >> setUp [

	  super setUp.

	  bus := self application busNamed: self busName
]

{ #category : #tests }
MiApplicationTest >> testBusNamed [

	| initialSize newBus |
	initialSize := self application buses size.
	newBus := self application busNamed: self alternativeBusName.

	self assert: newBus class identicalTo: MiBus.
	self assert: (self application buses includes: newBus).
	self assert: self application buses size equals: initialSize + 1.

	self application deleteBus: newBus
]

{ #category : #tests }
MiApplicationTest >> testDefaultBus [
	| default |
	default := self application defaultBus.
	self assert: default class identicalTo: MiBus.
	self assert: (self application buses includes: default)
]

{ #category : #tests }
MiApplicationTest >> testDeleteBus [
	| initialSize busToDelete |
	busToDelete := self application buses first.
	initialSize := self application buses size.

	self application deleteBus: busToDelete.

	self deny: (self application buses includes: busToDelete).
	self assert: self application buses size equals: initialSize - 1
]

{ #category : #tests }
MiApplicationTest >> testDeleteBusNamed [

	| initialSize |
	initialSize := self application buses size.
	
	self application deleteBusNamed: self application class defaultBusName.

	self deny:
		(self application buses anySatisfy: [ :app | 
			 app name = self application class defaultBusName ]).
	self assert: self application buses size equals: initialSize - 1
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testHandleJSONDropEvent [

	| dropped wasHandled |
	wasHandled := false.
	dropped := Mock named: 'dropped'.
	dropped stub wasHandled will: [ wasHandled := true ].

	(ExternalDropHandler lookupExternalDropHandler:
		 'whatever.json' asFileReference)
		handle: dropped
		in: nil
		dropEvent: nil.

	self assert: wasHandled
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testJSONRegisteredHandler [
	"There should be only 1 handler: MiApplication"

	| handlers |
	handlers := ExternalDropHandler registeredHandlers select: [ :handler |
		            handler extension = #json ].

	self assert: handlers size equals: 1.
	self assert: handlers anyOne handler equals: application
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testMSERegisteredHandler [

	| handlers |
	handlers := ExternalDropHandler registeredHandlers select: [ :handler |
		            handler extension = #mse ].

	self assert: handlers size equals: 1.
	self assert: handlers anyOne handler equals: application
]

{ #category : #tests }
MiApplicationTest >> testMiPropagate [
	"This test propagate an entity on the defaultBus and checks otherBuses are not changed"

	| mooseModel defaultBus otherBuses |
	mooseModel := MooseModel new.
	MooseEntity new mooseModel: mooseModel.

	"MiApplication sets any new bus created as default bus.
The rationale is: if a user creates a bus, the new bus has priority.
Here, we thus have to restore the initial default bus as actual default."
	defaultBus := application defaultBus.
	otherBuses := { 'bus1'. 'bus2'. 'bus3' } collect: [ :busName |
		              application busNamed: busName ].
	application defaultBus: defaultBus.

	mooseModel entities miPropagate.

	"Default bus has received the entity"
	self
		assertCollection: defaultBus logger mostRecentEntity
		hasSameElements: mooseModel entities.

	"Other buses have not."
	otherBuses do: [ :b | self assert: b logger mostRecentEntity isNil ]
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testMooseRootBrowserIsModelImporter [

	| browser |
	browser := application openCurrentModelsBrowser.
	self assert: browser class equals: MiModelsBrowser.
	browser window close
]

{ #category : #tests }
MiApplicationTest >> testOpenCurrentModelsBrowser [

	| browser1 browser2 |
	browser1 := application openCurrentModelsBrowser.
	self assert: browser1 class equals: MiModelsBrowser.

	"This should not open a new browser but get the first one"
	browser2 := application openCurrentModelsBrowser.
	self assert: browser2 class equals: MiModelsBrowser.
	self assert: browser1 equals: browser2.

	browser1 window close
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testUnregisterHandler [
	| jsonHandlers mseHandlers |
	jsonHandlers := ExternalDropHandler registeredHandlers
		select: [:handler | handler extension = #json].
	mseHandlers := ExternalDropHandler registeredHandlers
		select: [:handler | handler extension = #mse].

	application unregisterForDropFilesEvent.

	self assert:
		(ExternalDropHandler registeredHandlers
			select: [:handler | handler extension = #json]) size
	equals: jsonHandlers size - 1.
	self assert:
		(ExternalDropHandler registeredHandlers
			select: [:handler | handler extension = #mse]) size
	equals: mseHandlers size - 1.

]
