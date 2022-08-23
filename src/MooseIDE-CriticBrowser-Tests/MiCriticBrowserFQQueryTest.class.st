"
A MiCriticBrowserFQQueryTest is a test class for testing the behavior of MiCriticBrowserFQQuery
"
Class {
	#name : #MiCriticBrowserFQQueryTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #'as yet unclassified' }
MiCriticBrowserFQQueryTest >> intersectionQuery [

	| query class stubClass method |
	query := MiCriticBrowserFQQuery on: (FQStringQuery
		          property: #name
		          comparator: #beginsWith:
		          valueToCompare: 'Test')
	         & (FQBooleanQuery property: #isStub).
	class := FamixJavaClass new.
	class name: 'Test'.
	stubClass := FamixJavaClass new
		             name: 'TestStub';
		             stub: true.
	method := FamixJavaMethod new
		          name: 'methode';
		          stub: true.

	self assertCollection: (query runOnCollection: { class. stubClass. method } asMooseGroup) hasSameElements: { stubClass }
]

{ #category : #'as yet unclassified' }
MiCriticBrowserFQQueryTest >> queryWithParent [

	| query childQuery class stubClass method |
	query := MiCriticBrowserFQQuery on: (FQTypeQuery types: { FamixJavaClass }).
	childQuery := MiCriticBrowserFQQuery on: (FQBooleanQuery property: #isStub).
	childQuery query parent: query query.
	class := FamixJavaClass new. class name: 'Test'.
	stubClass := FamixJavaClass new. stubClass name: 'TestStub'; stub: true.
	method := FamixJavaMethod new. method name: 'methode'; stub: true.
	
	self assertCollection: (query runOnCollection: ({ class. stubClass. method } asMooseGroup) ) hasSameElements: { class. stubClass }. 
	self assertCollection: (childQuery runOnCollection: ({ class. stubClass. method } asMooseGroup) ) hasSameElements: { stubClass }. 
]

{ #category : #'as yet unclassified' }
MiCriticBrowserFQQueryTest >> singleQuery [

	| query class stubClass method |
	query := MiCriticBrowserFQQuery on: (FQBooleanQuery property: #isStub).
	class := FamixJavaClass new. class name: 'Test'.
	stubClass := FamixJavaClass new. stubClass name: 'TestStub'; stub: true.
	method := FamixJavaMethod new. method name: 'methode'; stub: true.
	
	self assertCollection: (query runOnCollection: ({ class. stubClass. method } asMooseGroup) ) hasSameElements: { method. stubClass }. 
]

{ #category : #'as yet unclassified' }
MiCriticBrowserFQQueryTest >> substractionQuery [

	| query class stubClass method |
	query := MiCriticBrowserFQQuery on: (FQStringQuery
		          property: #name
		          comparator: #beginsWith:
		          valueToCompare: 'Test')
	         \ (FQBooleanQuery property: #isStub).
	class := FamixJavaClass new.
	class name: 'Test'.
	stubClass := FamixJavaClass new
		             name: 'TestStub';
		             stub: true.
	method := FamixJavaMethod new
		          name: 'methode';
		          stub: true.

	self assertCollection: (query runOnCollection: { class. stubClass. method } asMooseGroup) hasSameElements: { class }
]

{ #category : #test }
MiCriticBrowserFQQueryTest >> testConvertToSTONString [
	| queryFQ queryCB queryOutput |
	queryFQ := FQBooleanQuery property: #isDead.
	queryFQ parent: (FQTypeQuery types: { FamixJavaMethod } ).
	queryCB := MiCriticBrowserFQQuery on: queryFQ.
	queryOutput := '(FQTypeQuery types: {FamixJavaMethod}) --> (FQBooleanQuery property: #isDead)'.
	self assert: queryCB convertToSTONString equals: queryOutput
	
]

{ #category : #test }
MiCriticBrowserFQQueryTest >> testRunOnCollection [
	
	self singleQuery.
	self testRunOnNAryQuery.
	self testRunOnQueryWithParent
]

{ #category : #test }
MiCriticBrowserFQQueryTest >> testRunOnNAryQuery [
	
	self substractionQuery.
	self intersectionQuery.
	self unionOfThreeQueries 

]

{ #category : #test }
MiCriticBrowserFQQueryTest >> testRunOnQueryWithParent [
	
	self queryWithParent.

]

{ #category : #'as yet unclassified' }
MiCriticBrowserFQQueryTest >> unionOfThreeQueries [

	| query class stubClass method attribute |
	query := MiCriticBrowserFQQuery on: (FQStringQuery
			          property: #name
			          comparator: #beginsWith:
			          valueToCompare: 'Test')
		         | (FQBooleanQuery property: #isStub)
		         | (FQTypeQuery types: { FamixJavaMethod }).
	class := FamixJavaClass new.
	class name: 'Test'.
	stubClass := FamixJavaClass new
		             name: 'TestStub';
		             stub: true.
	method := FamixJavaMethod new
		          name: 'methode';
		          stub: true.
	attribute := FamixJavaAttribute new name: 'PasTest'.
	self assertCollection: (query runOnCollection: { class. stubClass. method. attribute } asMooseGroup) hasSameElements: { class. stubClass. method. }
]
