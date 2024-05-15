"
A StMooseProcessorTest is a test class for testing the behavior of StMooseProcessor
"
Class {
	#name : #StMooseProcessorTest,
	#superclass : #StAbstractProcessorTest,
	#instVars : [
		'existingRoot'
	],
	#category : #'MooseIDE-Spotter-Tests'
}

{ #category : #tests }
StMooseProcessorTest >> processor [

	^ StMooseProcessor new 
]

{ #category : #tests }
StMooseProcessorTest >> setUp [

	existingRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot.
	super setUp
]

{ #category : #tests }
StMooseProcessorTest >> tearDown [

	MooseModelRoot resetRoot.
	MooseModelRoot installRoot: existingRoot.
	super tearDown
]

{ #category : #tests }
StMooseProcessorTest >> testEmptyQueryShowsNoResult [

	self runForText: ''.
	self assertQuantityOfResults: 0
]
