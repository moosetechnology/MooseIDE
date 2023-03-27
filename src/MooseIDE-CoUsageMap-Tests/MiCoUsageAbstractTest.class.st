Class {
	#name : #MiCoUsageAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'visualization',
		'builder'
	],
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #running }
MiCoUsageAbstractTest >> applicationForTests [

	^ MiTestApplication new
]

{ #category : #running }
MiCoUsageAbstractTest >> setUp [

	| browser |
	super setUp.

	browser := MiCoUsageMapBrowser
		newApplication: self applicationForTests
		model: self specModelForTests.
	browser model collectionModel: MiCoUsageTestFamixModel new allMethods.

	visualization := browser mapVisualization.

	builder := visualization mapBuilder.
	builder methods: browser model collectionModel
]

{ #category : #running }
MiCoUsageAbstractTest >> specModelForTests [

	^ MiCoUsageMapModel new
]
