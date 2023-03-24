"
A MiSaveQueriesCommandTest is a test class for testing the behavior of MiSaveQueriesCommand
"
Class {
	#name : #MiSaveQueriesCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'saver',
		'fixture'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Commands'
}

{ #category : #running }
MiSaveQueriesCommandTest >> setUp [

	super setUp.
	saver := MiSaveQueriesCommand new.
	fixture := SaveQueriesFixture new
]

{ #category : #tests }
MiSaveQueriesCommandTest >> testCopyQueriesReferencesOf [

	| copy original |
	original := fixture exampleForCopyingQueries.
	copy := saver copyQueriesReferencesOf: original.
	
	self assert: copy second parent equals: copy first.
	self assert: copy third parent equals: copy second.
	
	self assert: copy first children anyOne equals: copy second.
	self assert: copy second children anyOne equals: copy third.
	
	self deny: copy equals: original.
	copy
		with: original
		do: [ :a :b | self deny: a equals: b ].
	copy
		with: original
		do: [ :a :b | 
		a parent ifNotNil: [ self deny: a parent equals: b parent ] ].
	copy
		with: original
		do: [ :a :b | 
		a children
			ifNotEmpty: [ self deny: a children anyOne equals: b children anyOne ] ]
]

{ #category : #tests }
MiSaveQueriesCommandTest >> testPutChildrenInPlace [

	| sortedQueriesWithChildreInPlace |
	"https://i.imgur.com/n6dfMHQ.png"
	sortedQueriesWithChildreInPlace := saver putChildrenInPlace: fixture expectedTopologicalOrder.

	self
		assert: sortedQueriesWithChildreInPlace asOrderedCollection
		equals: fixture expectedChildrenInPlaceOrder asOrderedCollection
]

{ #category : #tests }
MiSaveQueriesCommandTest >> testTopologicalSortForQueries [

	| query1 query2 complementQuery andQuery resultSize orQuery unSortedQueries sortedQueries query3 complement2 |
	query1 := FQBooleanQuery property: #isStub.
	query2 := FQStringQuery
		          property: #name
		          comparator: #includesSubstring:
		          valueToCompare: ''.
	query3 := FQTypeQuery types: (OrderedCollection with: FamixStClass).
	complementQuery := FQComplementQuery queryToNegate: query2.
	complement2 := FQComplementQuery queryToNegate: query3.
	resultSize := FQResultSizeQuery
		              innerQuery: complementQuery
		              comparator: #>
		              valueToCompare: 9.
	andQuery := FQIntersectionQuery subqueries: {
			            query1.
			            query2.
			            resultSize }.
	orQuery := FQUnionQuery subqueries: {
			           andQuery.
			           query1.
			           complement2 }.

	unSortedQueries := {
		                   orQuery.
		                   query1.
		                   query2.
		                   andQuery.
		                   resultSize.
		                   complementQuery.
		                   query3.
		                   complement2 } shuffle.
	sortedQueries := saver topologicalSortForQueries: unSortedQueries.

	self assert: (sortedQueries indexOf: complementQuery)
		< (sortedQueries indexOf: resultSize).
	self assert: sortedQueries nextToLast equals: andQuery.
	self assert: sortedQueries last equals: orQuery
]

{ #category : #tests }
MiSaveQueriesCommandTest >> testTopologicalSortForQueries2 [

	| sortedQueries |
	"https://i.imgur.com/n6dfMHQ.png"
	sortedQueries := saver topologicalSortForQueries:
		                 fixture unsortedQueries.

	self
		assert: sortedQueries
		equals: fixture expectedTopologicalOrder asOrderedCollection
]
