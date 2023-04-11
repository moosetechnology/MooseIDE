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
MiCoUsageAbstractTest >> createTag: aName [
	^(builder specModel currentMooseModel tagNamed: aName)
		color: (Color red) ;
		yourself
]

{ #category : #running }
MiCoUsageAbstractTest >> setUp [

	| browser |
	super setUp.

	browser := MiCoUsageMapBrowser
		newApplication: MiTestApplication new
		model: MiCoUsageMapModel new.
	browser model followEntity: MiCoUsageTestFamixModel new allMethods.

	visualization := browser mapVisualization.

	builder := visualization mapBuilder.
	"builder containerEntities: browser model collectionModel"
]

{ #category : #running }
MiCoUsageAbstractTest >> specModel [
	^visualization specModel
]

{ #category : #'private - testing' }
MiCoUsageAbstractTest >> tagsWithPalette: aCollection [
	aCollection do: [:str |
		(self createTag: str)
			color: (NSScale category20 scale: str) ]
]
