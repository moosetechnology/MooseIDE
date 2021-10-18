"
A MiSaveQueriesCommandTest is a test class for testing the behavior of MiSaveQueriesCommand
"
Class {
	#name : #MiSaveQueriesCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'saver'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Commands'
}

{ #category : #running }
MiSaveQueriesCommandTest >> setUp [

	super setUp.
	saver := MiSaveQueriesCommand new
]

{ #category : #test }
MiSaveQueriesCommandTest >> testSortQueries [

	| query1 query2 complementQuery andQuery resultSize orQuery unSortedQueries sortedQueries |
	query1 := FQBooleanQuery property: #isStub.
	query2 := FQStringQuery property: #name comparator: #includesSubstring: valueToCompare: ''.
	complementQuery := FQComplementQuery queryToNegate: query2.
	andQuery := FQIntersectionQuery subqueries: { query1. query2. complementQuery }.
	resultSize := FQResultSizeQuery innerQuery: complementQuery comparator: #> valueToCompare: 9.
	orQuery := FQUnionQuery subqueries: { andQuery. query1 }.
	unSortedQueries := { query1 . query2 . orQuery . andQuery . resultSize . complementQuery }.
	sortedQueries := saver sortQueries: unSortedQueries.
	self assert: sortedQueries last equals: orQuery.
	self assert: (sortedQueries at: 3) equals: complementQuery
]
