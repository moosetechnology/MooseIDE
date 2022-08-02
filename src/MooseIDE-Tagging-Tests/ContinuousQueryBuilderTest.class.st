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
	comparator := { #<=. #<=. #>. #<=. }.
	bounds := { 5. 15. 25. 50 }.
	
	strategy := ContinuousQueryBuilder new property: property1; comparator: comparator; bounds: bounds.
	
	selectedMethod := FamixJavaMethod new cyclomaticComplexity: 4.
	notSelectedMethod := FamixJavaMethod new cyclomaticComplexity: 12.
	
	selectedClass := FamixJavaClass new numberOfMethods: 13.
	selectedClass2 := FamixJavaClass new numberOfMethods: 42.
	
	
	
	
	
	
]

{ #category : #test }
ContinuousQueryBuilderTest >> testBuildNameForIndex [

	self assert: (strategy buildNameForIndex: 1) equals: 'cyclomaticComplexity <= 5'.
	self assert: (strategy buildNameForIndex: 2) equals: 'cyclomaticComplexity <= 15'.
	self assert: (strategy buildNameForIndex: 3) equals: 'cyclomaticComplexity > 25'.
	self assert: (strategy buildNameForIndex: 4) equals: 'cyclomaticComplexity <= 50'.
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
