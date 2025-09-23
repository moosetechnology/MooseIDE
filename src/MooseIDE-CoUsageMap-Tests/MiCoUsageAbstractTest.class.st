Class {
	#name : 'MiCoUsageAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'visualization',
		'builder',
		'browser',
		'application',
		'previousApplication'
	],
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'running' }
MiCoUsageAbstractTest >> createTag: aName [

	^ (builder specModel currentMooseModel tagNamed: aName)
		  color: Color red;
		  yourself
]

{ #category : 'running' }
MiCoUsageAbstractTest >> setUp [

	super setUp.
	previousApplication := MiApplication current.

	application := MiTestApplication new.
	MiApplication current: application.

	browser := MiCoUsageMapBrowser
		           newApplication: application
		           model: MiCoUsageMapModel new.

	browser specModel followEntity:
		MiCoUsageTestFamixModel new allMethods.

	visualization := browser mapVisualization.

	builder := visualization mapBuilder
]

{ #category : 'running' }
MiCoUsageAbstractTest >> specModel [

	^ visualization specModel
]

{ #category : 'private - testing' }
MiCoUsageAbstractTest >> tagsWithPalette: aCollection [

	aCollection do: [ :str |
		(self createTag: str) color: (NSScale category20 scale: str) ]
]

{ #category : 'running' }
MiCoUsageAbstractTest >> tearDown [

	MiApplication reset.
	MiApplication current: previousApplication.
	super tearDown
]
