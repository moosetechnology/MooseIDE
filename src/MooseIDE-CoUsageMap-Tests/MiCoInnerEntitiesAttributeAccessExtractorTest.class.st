Class {
	#name : 'MiCoInnerEntitiesAttributeAccessExtractorTest',
	#superclass : 'TestCase',
	#instVars : [
		'mooseModel',
		'extractor'
	],
	#category : 'MooseIDE-CoUsageMap-Tests-Model',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> setUp [
	super setUp.

	mooseModel := MiCoUsageTestFamixModel new.
	extractor := MiCoInnerEntitiesAttributeAccessExtractor new
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testAttributeAccessorInvocationsNone [

	self assert: (extractor attributeAccessorInvocations: mooseModel method5) size equals: 0
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testAttributeAccessorInvocationsOne [

	self assert: (extractor attributeAccessorInvocations: mooseModel method2) size equals: 1.

	self
		assertCollection: (extractor attributeAccessorInvocations: mooseModel method2)
		hasSameElements: { mooseModel att6 }.
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testDirectAttributeAccessesMultipleAccesses [

	self assert: (extractor directAttributeAccesses: mooseModel method1) size equals: 3.

	self
		assertCollection: (extractor directAttributeAccesses: mooseModel method1)
		hasSameElements: { mooseModel att1 . mooseModel att1 . mooseModel att1 }.
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testDirectAttributeAccessesMultipleAttributes [

	self assert: (extractor directAttributeAccesses: mooseModel method3) size equals: 3.

	self
		assertCollection: (extractor directAttributeAccesses: mooseModel method3)
		hasSameElements: { mooseModel att3 . mooseModel att4 . mooseModel att5 }.
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testDirectAttributeAccessesNone [

	self assert: (extractor directAttributeAccesses: mooseModel method2) size equals: 0
]

{ #category : 'tests' }
MiCoInnerEntitiesAttributeAccessExtractorTest >> testInnerEntitiesFor [

	self
		assertCollection: (extractor innerEntitiesFor: mooseModel method2)
		hasSameElements: { mooseModel att6 }.

	self
		assertCollection: (extractor innerEntitiesFor: mooseModel method3)
		hasSameElements: { mooseModel att3 . mooseModel att4 . mooseModel att5 }.
]
