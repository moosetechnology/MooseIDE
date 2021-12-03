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
	^ MiTestApplication current
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

{ #category : #running }
MiApplicationTest >> tearDown [

	self application reset.
	super tearDown
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
	| initialSize |
	initialSize := self application buses size.

	self application deleteBus: bus.

	self deny: (self application buses includes: bus).
	self assert: self application buses size equals: initialSize - 1
]

{ #category : #tests }
MiApplicationTest >> testDeleteBusNamed [

	| initialSize |
	initialSize := self application buses size.
	self application deleteBusNamed: self busName.

	self deny:
		(self application buses anySatisfy: [ :app | 
			 app name = self busName ]).
	self deny: (self application buses includes: bus).
	self assert: self application buses size equals: initialSize - 1
]
