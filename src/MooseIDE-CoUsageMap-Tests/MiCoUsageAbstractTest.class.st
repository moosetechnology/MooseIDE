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

{ #category : #'private - testing' }
MiCoUsageAbstractTest >> buildForTest [
	builder renderIn: builder container job: MiJob new.

]

{ #category : #running }
MiCoUsageAbstractTest >> createTag: aName [
	^builder containerEntities anyOne mooseModel tagNamed: aName
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
	builder containerEntities: browser model collectionModel
]

{ #category : #running }
MiCoUsageAbstractTest >> specModelForTests [

	^ MiCoUsageMapModel new
]

{ #category : #'private - testing' }
MiCoUsageAbstractTest >> tags: aCollection colorPalette: aNSOrdinalScale [
	aCollection do: [:str |
		self addTag: (FamixTag new 
			name: str;
			color: (aNSOrdinalScale scale: str);
			yourself) ].
]

{ #category : #'private - testing' }
MiCoUsageAbstractTest >> tagsWithPalette: aCollection [
	aCollection do: [:str |
		(self createTag: str)
			color: (NSScale category20 scale: str) ]
]
