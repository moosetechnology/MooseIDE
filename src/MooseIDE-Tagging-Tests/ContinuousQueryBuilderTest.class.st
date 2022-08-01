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
		'notSelectedClass'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
ContinuousQueryBuilderTest >> setUp [
	super setUp.
	
	property1 := #cyclomaticComplexity.
	property2 := #numberOfMethods.
	comparator := #<=.
	bounds := { 5. 15. 25. 50 }.
	
	strategy := ContinuousQueryBuilder new property: property1; comparator: comparator; bounds: bounds.
	
	selectedMethod := FamixJavaMethod new cyclomaticComplexity: 4.
	notSelectedMethod := FamixJavaMethod new cyclomaticComplexity: 12.
	
	selectedClass := FamixJavaClass new numberOfMethods: 13.
	notSelectedClass := FamixJavaClass new numberOfMethods: 42.
	
	
	
	
	
	
]

{ #category : #test }
ContinuousQueryBuilderTest >> testBuildSelectBlockOfIndex [

	| query1 query2 |
	query1 := strategy buildSelectBlockOfIndex: 1.
	self assertCollection: ({ selectedMethod. notSelectedMethod } select: query1) hasSameElements: { selectedMethod }.
	
	strategy property: property2.
	query2 := strategy buildSelectBlockOfIndex: 2.
	self assertCollection: ({ selectedClass. notSelectedClass } select: query2) hasSameElements: { selectedClass }
]
