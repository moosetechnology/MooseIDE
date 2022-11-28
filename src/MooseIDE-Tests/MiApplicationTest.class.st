Class {
	#name : #MiApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'bus'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiApplicationTest >> alternativeBusName [
	^ 'TestBus2'
]

{ #category : #running }
MiApplicationTest >> application [

	  ^ application
]

{ #category : #running }
MiApplicationTest >> busName [

	^ 'Not the default bus'
]

{ #category : #running }
MiApplicationTest >> setUp [

	  super setUp.
	  application := MiTestApplication new.
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
