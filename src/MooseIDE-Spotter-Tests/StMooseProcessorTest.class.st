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

{ #category : #running }
StMooseProcessorTest >> setUp [

	super setUp.
	existingRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot
]

{ #category : #running }
StMooseProcessorTest >> tearDown [

	MooseModelRoot resetRoot.
	MooseModelRoot installRoot: existingRoot.
	super tearDown
]

{ #category : #tests }
StMooseProcessorTest >> testEmptyEvenWithExistingModel [

	| stModel aStClass |
	stModel := FamixStModel new.
	aStClass := stModel newClassNamed: 'aClass'.
	stModel install.

	self runForText: ''.
	self assertQuantityOfResults: 0
]

{ #category : #tests }
StMooseProcessorTest >> testEmptyQueryShowsNoResult [

	self runForText: ''.
	self assertQuantityOfResults: 0
]

{ #category : #tests }
StMooseProcessorTest >> testOneNamedClassUsingFamixSt [

	| stModel aStClass |
	stModel := FamixStModel new.
	aStClass := stModel newClassNamed: 'aClass'.
	stModel install.

	self runForText: 'aCl'.
	self assertQuantityOfResults: 1.
	self assertResultsIncludes: aStClass
]
