"
A MiCriticBrowserFQQueryTest is a test class for testing the behavior of MiCriticBrowserFQQuery
"
Class {
	#name : #MiCriticBrowserFQQueryTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #queries }
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

{ #category : #queries }
MiCriticBrowserFQQueryTest >> queryWithParent [

	| query childQuery class stubClass method |
	query := MiCriticBrowserFQQuery on:
		         (FQTypeQuery types: { FamixJavaClass }).
	childQuery := MiCriticBrowserFQQuery on:
		              (FQBooleanQuery property: #isStub).
	childQuery innerQuery parent: query innerQuery.
	class := FamixJavaClass new.
	class name: 'Test'.
	stubClass := FamixJavaClass new.
	stubClass
		name: 'TestStub';
		stub: true.
	method := FamixJavaMethod new.
	method
		name: 'methode';
		stub: true.

	self
		assertCollection: (query runOnCollection: {
					 class.
					 stubClass.
					 method } asMooseGroup)
		hasSameElements: {
				class.
				stubClass }.
	self
		assertCollection: (childQuery runOnCollection: {
					 class.
					 stubClass.
					 method } asMooseGroup)
		hasSameElements: { stubClass }
]

{ #category : #queries }
MiCriticBrowserFQQueryTest >> singleQuery [

	| query class stubClass method |
	query := MiCriticBrowserFQQuery on: (FQBooleanQuery property: #isStub).
	class := FamixJavaClass new. class name: 'Test'.
	stubClass := FamixJavaClass new. stubClass name: 'TestStub'; stub: true.
	method := FamixJavaMethod new. method name: 'methode'; stub: true.
	
	self assertCollection: (query runOnCollection: ({ class. stubClass. method } asMooseGroup) ) hasSameElements: { method. stubClass }. 
]

{ #category : #queries }
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

{ #category : #tests }
MiCriticBrowserFQQueryTest >> testConvertToSTONString [

	| queryFQ queryCB queryOutput |
	queryFQ := FQBooleanQuery property: #isDead.
	queryFQ parent: (FQTypeQuery types: { FamixJavaMethod }).
	queryCB := MiCriticBrowserFQQuery on: queryFQ.
	queryOutput := '(FQTypeQuery types: {FamixJavaMethod}) --> (FQBooleanQuery property: #isDead)'.
	self assert: queryCB convertToSTONString equals: queryOutput
]

{ #category : #tests }
MiCriticBrowserFQQueryTest >> testRunOnCollection [
	
	self singleQuery.
	self testRunOnNAryQuery.
	self testRunOnQueryWithParent
]

{ #category : #tests }
MiCriticBrowserFQQueryTest >> testRunOnNAryQuery [
	
	self substractionQuery.
	self intersectionQuery.
	self unionOfThreeQueries 

]

{ #category : #tests }
MiCriticBrowserFQQueryTest >> testRunOnQueryWithParent [
	
	self queryWithParent.

]

{ #category : #queries }
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
