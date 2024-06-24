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

{ #category : #initialization }
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
	
	self application deleteBus: newBus.
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
	"must reset (i.e. remove) MiApplication singleton instance
	 for MiTestApplication special handling method to be asked to handle the drop"
	| dropped wasHandled |
	wasHandled := false.
	dropped := Mock named: 'dropped'.
	(dropped stub wasHandled) will: [ wasHandled := true].

	MiApplication reset.
	(ExternalDropHandler lookupExternalDropHandler: 'whatever.json' asFileReference)
		handle: dropped in: nil dropEvent: nil.

	self assert: wasHandled.
	
	"recreate MiApplication instance to go back to normal"
	MiApplication current
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testJSONRegisteredHandler [
	"There should be only 2 handlers: MiApplication & MiTestApplication
	 
	Other tests may fail and not unregister their MiTestApplication, so we clean first the
	registeredHandlers, then we recreate a MiTestApplication and we can perfrom the actual test"
	
	ExternalDropHandler registeredHandlers copy do: [ :registeredHandler |
		(registeredHandler handler class = MiTestApplication)
		ifTrue: [ ExternalDropHandler registeredHandlers remove: registeredHandler ]
	].
	application := MiTestApplication new.

	self assert: (ExternalDropHandler registeredHandlers select: [:handler | handler extension = #json]) size equals: 2.

]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testMSERegisteredHandler [
	"There should be only 2 handlers: MiApplication & MiTestApplication
	 
	Other tests may fail and not unregister their MiTestApplication, so we clean first the
	registeredHandlers, then we recreate a MiTestApplication and we can perfrom the actual test"
	
	ExternalDropHandler registeredHandlers copy do: [ :registeredHandler |
		(registeredHandler handler class = MiTestApplication)
		ifTrue: [ ExternalDropHandler registeredHandlers remove: registeredHandler ]
	].
	application := MiTestApplication new.

	self assert: (ExternalDropHandler registeredHandlers select: [:handler | handler extension = #mse]) size equals: 2.

]

{ #category : #tests }
MiApplicationTest >> testMiPropagate [
	| mooseModel defaultBus otherBuses originalMostRecentEntities newMostRecentEntities |
	
	mooseModel := MooseModel new.
	MooseEntity new mooseModel: mooseModel.
	defaultBus :=  MiApplication current  buses 
		detect: [ :b | b name = MiApplication defaultBusName ]
		ifNone: [ self expectedFailures ].
	otherBuses := MiApplication current  buses reject: [:b | b = defaultBus].

	originalMostRecentEntities := otherBuses collect: [ :b | b logger mostRecentEntity ]. 
	
	mooseModel entities miPropagate.
	
	newMostRecentEntities := otherBuses collect: [ :b | b logger mostRecentEntity ]. 	 
	self assertCollection: originalMostRecentEntities hasSameElements: newMostRecentEntities .
	
	self assertCollection:  defaultBus logger mostRecentEntity hasSameElements: mooseModel entities  .

	"Tear down: Removing the entity we propagated on the default bus"
	defaultBus logger removeLog: (defaultBus logger mostRecentLog ) .
	
]

{ #category : #'tests dragNDrop' }
MiApplicationTest >> testMooseRootBrowserIsModelImporter [
	| browser |
	browser := application openCurrentModelsBrowser.
	self assert: browser class equals: MiModelsBrowser.
	browser window close
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
