"
I am a fixture for MiSaveQueriesCommandTest.

See https://i.imgur.com/n6dfMHQ.png
"
Class {
	#name : #SaveQueriesFixture,
	#superclass : #Object,
	#instVars : [
		'q1',
		'q2',
		'q3',
		'q5',
		'q4',
		'q7',
		'q6',
		'q8',
		'q9',
		'q10'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Commands'
}

{ #category : #accessing }
SaveQueriesFixture >> exampleForCopyingQueries [

	| root firstLevel secondLevel thirdLevel |
	root := FQRootQuery new
		result: FQTestsHelper new classesAndMethods;
		yourself.
	firstLevel := FQBooleanQuery property: #isStub.
	firstLevel beChildOf: root.
	secondLevel := FQBooleanQuery property: #isDead.
	secondLevel beChildOf: firstLevel.
	thirdLevel := FQBooleanQuery property: #containsReplicas.
	thirdLevel beChildOf: secondLevel.
	^ { firstLevel. secondLevel. thirdLevel }
]

{ #category : #accessing }
SaveQueriesFixture >> expectedChildrenInPlaceOrder [

	^ {
		q2. q5. q7.
		q3. q6.
		q1. q8. q10.
		q4. q9 }
]

{ #category : #accessing }
SaveQueriesFixture >> expectedTopologicalOrder [

	^ {
		q2. q1. q5. q7.		"Level 0"
		q8. q3. q6.			"Level 1"
		q10. q4.				"Level 2"
		q9 }					"Level 3"
]

{ #category : #initialization }
SaveQueriesFixture >> initialize [

	q1 := FQBooleanQuery property: #isDead.
	q2 := FQTypeQuery types: (OrderedCollection with: FamixStClass).
	q3 := FQComplementQuery queryToNegate: q2.
	q5 := FQBooleanQuery property: #isStub.
	q4 := FQIntersectionQuery subqueries: {
			      q3.
			      q1.
			      q5 }.
	q7 := FQBooleanQuery property: #containsReplicas.
	q6 := FQResultSizeQuery
		      innerQuery: q7
		      comparator: #>
		      valueToCompare: 0.
	q8 := FQBooleanQuery property: #isStub.
	q9 := FQBooleanQuery property: #isTagged.
	q10 := FQResultSizeQuery
		       innerQuery: q7
		       comparator: #>
		       valueToCompare: 1.

	q8 beChildOf: q1.
	q10 beChildOf: q8.
	q9 beChildOf: q4
]

{ #category : #accessing }
SaveQueriesFixture >> unsortedQueries [

	"Besides the example in the image, we change the order of the children"

	^ { q8. q10. q2. q1. q3. q4. q9. q5. q6. q7 }
]
