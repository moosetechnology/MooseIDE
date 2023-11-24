"
A MiCriticBrowserFQQueryTest is a test class for testing the behavior of MiCriticBrowserFQQuery
"
Class {
	#name : #MiCBQueryHandlerTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #queries }
MiCBQueryHandlerTest >> intersectionQuery [

	| query class stubClass method |
	query := FamixCBQueryHandler on: (FQStringQuery
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

	self
		assertCollection: (query runOnCollection: {
					 class.
					 stubClass.
					 method } asMooseGroup)
		hasSameElements: { stubClass }
]

{ #category : #queries }
MiCBQueryHandlerTest >> queryWithParent [

	| query childQuery class stubClass method |
	query := FamixCBQueryHandler on:
		         (FQTypeQuery types: { FamixJavaClass }).
	childQuery := FamixCBQueryHandler on:
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
MiCBQueryHandlerTest >> singleQuery [

	| query class stubClass method |
	query := FamixCBQueryHandler on: (FQBooleanQuery property: #isStub).
	class := FamixJavaClass new. class name: 'Test'.
	stubClass := FamixJavaClass new. stubClass name: 'TestStub'; stub: true.
	method := FamixJavaMethod new. method name: 'methode'; stub: true.
	
	self assertCollection: (query runOnCollection: ({ class. stubClass. method } asMooseGroup) ) hasSameElements: { method. stubClass }. 
]

{ #category : #queries }
MiCBQueryHandlerTest >> substractionQuery [

	| query class stubClass method |
	query := FamixCBQueryHandler on: (FQStringQuery
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

	self
		assertCollection: (query runOnCollection: {
					 class.
					 stubClass.
					 method } asMooseGroup)
		hasSameElements: { class }
]

{ #category : #tests }
MiCBQueryHandlerTest >> testAsRuleEditorString [

	| queryFQ |
	"queryFQ := FQBooleanQuery property: #isDead.
	queryFQ parent: (FQTypeQuery types: { FamixJavaMethod })."
	queryFQ := FQSelectScriptQuery script: [ :entity | entity name includesSubstring: 'Rule' ].

	self
		assert: (FamixCBQueryHandler on: queryFQ) asRuleEditorString
		equals: '[ :entity | entity name includesSubstring: ''Rule'' ]'
]

{ #category : #tests }
MiCBQueryHandlerTest >> testConvertToSTONString [

	| queryFQ |
	queryFQ := FQBooleanQuery property: #isDead.
	queryFQ parent: (FQTypeQuery types: { FamixJavaMethod }).

	self
		assert: (FamixCBQueryHandler on: queryFQ) convertToSTONString
		equals:
		'(FQTypeQuery types: {FamixJavaMethod}) --> (FQBooleanQuery property: #isDead)'
]

{ #category : #tests }
MiCBQueryHandlerTest >> testRunOnCollection [
	
	self singleQuery.
	self testRunOnNAryQuery.
	self testRunOnQueryWithParent
]

{ #category : #tests }
MiCBQueryHandlerTest >> testRunOnNAryQuery [
	
	self substractionQuery.
	self intersectionQuery.
	self unionOfThreeQueries 

]

{ #category : #tests }
MiCBQueryHandlerTest >> testRunOnQueryWithParent [
	
	self queryWithParent.

]

{ #category : #queries }
MiCBQueryHandlerTest >> unionOfThreeQueries [

	| query class stubClass method attribute |
	query := FamixCBQueryHandler on: (FQStringQuery
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
	self
		assertCollection: (query runOnCollection: {
					 class.
					 stubClass.
					 method.
					 attribute } asMooseGroup)
		hasSameElements: {
				class.
				stubClass.
				method }
]
