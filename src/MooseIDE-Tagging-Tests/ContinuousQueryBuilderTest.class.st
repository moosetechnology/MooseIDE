"
A ContinuousQueryBuilderTest is a test class for testing the behavior of ContinuousQueryBuilder
"
Class {
	#name : #ContinuousQueryBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'property1',
		'property2',
		'comparator',
		'bounds',
		'strategy',
		'selectedMethod',
		'notSelectedMethod',
		'selectedClass',
		'selectedClass2'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
ContinuousQueryBuilderTest >> setUp [
	super setUp.
	
	property1 := #cyclomaticComplexity.
	property2 := #numberOfMethods.
	bounds := { 5. 15. 25. 50 }.
	
	strategy := ContinuousQueryBuilder new property: property1; bounds: bounds.
	
	selectedMethod := FamixJavaMethod new cyclomaticComplexity: 4.
	notSelectedMethod := FamixJavaMethod new cyclomaticComplexity: 12.
	
	selectedClass := FamixJavaClass new numberOfMethods: 13.
	selectedClass2 := FamixJavaClass new numberOfMethods: 42.
	
	
	
	
	
	
]

{ #category : #test }
ContinuousQueryBuilderTest >> testBuildNameForBoundAndComparator [

	"bounds := { 5. 15. 25. 50 }"
	self assert: (strategy buildNameForBound: 5 andComparator: '<=' ) equals: 'cyclomaticComplexity <= 5'.
	self assert: (strategy buildNameForBound: 15 andComparator: '<' ) equals: 'cyclomaticComplexity < 15'.
	self assert: (strategy buildNameForBound: 25 andComparator: '=' ) equals: 'cyclomaticComplexity = 25'.
	self assert: (strategy buildNameForBound: 50 andComparator: '>' ) equals: 'cyclomaticComplexity > 50'.
]

{ #category : #test }
ContinuousQueryBuilderTest >> testBuildSelectBlockForBoundAndComparator [

	| query1 query2 query3 query4 |
	"bounds := { 5. 15. 25. 50 }."
	query1 := strategy buildSelectBlockForBound: 5 andComparator: '<='.
	self assertCollection: ({ selectedMethod. notSelectedMethod } select: query1) hasSameElements: { selectedMethod }.
	
	strategy property: property2.
	query2 := strategy buildSelectBlockForBound: 15 andComparator: '<='.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query2) hasSameElements: { selectedClass }.
	
	query3 := strategy buildSelectBlockForBound: 25 andComparator: '>'.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query3) hasSameElements: { selectedClass2 }.
	
	query4 := strategy buildSelectBlockForBound: 50 andComparator: '<='.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query4) hasSameElements: { selectedClass. selectedClass2 }
]

{ #category : #test }
ContinuousQueryBuilderTest >> testBuildSelectBlockForIndex [

	| query1 query2 query3 query4 |
	query1 := strategy buildSelectBlockForIndex: 1.
	self assertCollection: ({ selectedMethod. notSelectedMethod } select: query1) hasSameElements: { selectedMethod }.
	
	strategy property: property2.
	query2 := strategy buildSelectBlockForIndex: 2.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query2) hasSameElements: { selectedClass }.
	
	query3 := strategy buildSelectBlockForIndex: 3.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query3) hasSameElements: { selectedClass2 }.
	
	query4 := strategy buildSelectBlockForIndex: 4.
	self assertCollection: ({ selectedClass. selectedClass2 } select: query4) hasSameElements: { selectedClass. selectedClass2 }
]
