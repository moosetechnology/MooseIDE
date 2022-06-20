"
A MiCriticBrowserFQQueryTest is a test class for testing the behavior of MiCriticBrowserFQQuery
"
Class {
	#name : #MiCriticBrowserFQQueryTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

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
