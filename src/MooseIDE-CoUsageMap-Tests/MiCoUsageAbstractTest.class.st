Class {
	#name : 'MiCoUsageAbstractTest',
	#superclass : 'MiAbstractApplicationTest',
	#instVars : [
		'visualization',
		'builder',
		'mooseModel',
		'browser'
	],
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'testing' }
MiCoUsageAbstractTest class >> isAbstract [
	^self name includesSubstring: 'Abstract'
]

{ #category : 'running' }
MiCoUsageAbstractTest >> browserClass [

	^MiCoUsageMapBrowser
]

{ #category : 'running' }
MiCoUsageAbstractTest >> createTag: aName [

	^ (builder specModel currentMooseModel tagNamed: aName)
		  color: Color red;
		  yourself
]

{ #category : 'running' }
MiCoUsageAbstractTest >> setUp [

	super setUp.

	mooseModel := MiCoUsageTestFamixModel new.

	browser := self browserClass openForTests: application.
	browser followEntity: mooseModel allMethods.

	visualization := browser mapVisualization.
	builder := visualization mapBuilder
]

{ #category : 'running' }
MiCoUsageAbstractTest >> specModel [

	^ browser specModel
]

{ #category : 'private - testing' }
MiCoUsageAbstractTest >> tagsWithPalette: aCollection [

	aCollection do: [ :str |
		(self createTag: str) color: (NSScale category20 scale: str) ]
]

{ #category : 'running' }
MiCoUsageAbstractTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].

	super tearDown
]
