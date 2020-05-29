"
A MiLoggerTest is a test class for testing the behavior of MiLogger
"
Class {
	#name : #MiLoggerTest,
	#superclass : #TestCase,
	#instVars : [
		'logger'
	],
	#category : #'Midas-Tests'
}

{ #category : #accessing }
MiLoggerTest >> logger [
	^ logger
]

{ #category : #running }
MiLoggerTest >> refreshBrowsersWith: anEntity [
	"do nothing.. I'm here for the tests"
]

{ #category : #running }
MiLoggerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	logger := MiLogger new
		application: self;
		yourself
]

{ #category : #tests }
MiLoggerTest >> testClean [
	| logs |
	logs := logger logs.
	logger logs
		add:
			(MiSelectedEntityLog new
				logger: logger;
				entity: self).
	self assert: self logger logs isNotEmpty.
	logger clean.
	self assert: self logger logs isEmpty.
	self assert: self logger logs == logs
]

{ #category : #tests }
MiLoggerTest >> testRemoveEntry [
	| entity1 entity2 |
	entity1 := MiSelectedEntityLog new
		logger: logger;
		entity: 2.
	entity2 := MiSelectedEntityLog new
		logger: logger;
		entity: 1.
	self logger logs add: entity1.
	self logger logs add: entity2.

	self assert: self logger logs size equals: 2.
	self logger removeLog: entity2.

	self assert: (self logger logs includes: entity1).
	self deny: (self logger logs includes: entity2).
	self assert: self logger logs size equals: 1
]
