"
A MiLoggerTest is a test class for testing the behavior of MiLogger
"
Class {
	#name : #MiLoggerTest,
	#superclass : #TestCase,
	#instVars : [
		'logger'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiLoggerTest >> setUp [
	logger := MiLogger new
]

{ #category : #tests }
MiLoggerTest >> testClean [
	| logs |
	logs := logger logs.
	self assert: logs isEmpty.
	
	logger newLogFor: MooseEntity new.
	self assert: logger logs isNotEmpty.
	
	logger clean.
	self assert: logger logs isEmpty.
	self assert: logger logs identicalTo: logs
]

{ #category : #tests }
MiLoggerTest >> testMostRecentEntity [
	| entity |
	self assert: logger mostRecentEntity isNil.
	entity := MooseEntity new.
	logger newLogFor: entity.
	self assert: logger mostRecentEntity identicalTo: entity
]

{ #category : #tests }
MiLoggerTest >> testMostRecentLog [
	| log |
	self assert: logger mostRecentLog isNil.
	log := logger newLogFor: MooseEntity new.
	self assert: logger mostRecentLog identicalTo: log
]

{ #category : #tests }
MiLoggerTest >> testNewLogFor [
	| entity group firstLog secondLog thirdLog |
	entity := MooseEntity new.

	"Logging an entity --> log creation"
	firstLog := logger newLogFor: entity.
	self assert: firstLog class identicalTo: MiSelectedEntityLog.
	self assert: firstLog entity identicalTo: entity.
	self assertCollection: logger logs hasSameElements: {firstLog}.

	"Logging the same entity --> returning the previous log"
	secondLog := logger newLogFor: entity.
	self assert: secondLog identicalTo: firstLog.
	self assertCollection: logger logs hasSameElements: {firstLog}.

	"Logging another entity --> new log"
	group := MooseGroup new.
	thirdLog := logger newLogFor: group.
	self assert: thirdLog class identicalTo: MiSelectedEntityLog.
	self assert: thirdLog entity identicalTo: group.
	self
		assertCollection: logger logs
		hasSameElements:
			{firstLog.
			thirdLog}
]

{ #category : #tests }
MiLoggerTest >> testRemoveLog [
	| firstLog secondLog |
	firstLog := logger newLogFor: MooseEntity new.
	secondLog := logger newLogFor: MooseGroup new.

	"Remove logs"
	logger removeLog: secondLog.
	self assertCollection: logger logs hasSameElements: {firstLog}
]
