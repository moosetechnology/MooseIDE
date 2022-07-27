Class {
	#name : #GradualTagsGenerationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy',
		'query',
		'query2',
		'context',
		'condition',
		'condition2',
		'violatingEntity',
		'entity'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #initialization }
GradualTagsGenerationStrategyTest >> setUp [
	super setUp.
	
	strategy := GradualTagsGenerationStrategy new
		tagClass: MiQueryTag.
	
	query := FQBooleanQuery property: #isStub.
	query2 := FQBooleanQuery property: #isDead.
	
	context := FamixCBRootContext named: 'root' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	condition2 := FamixCBCondition named: 'test2' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]')).
	context addChild: condition; addChild: condition2.
	
	violatingEntity := FamixJavaMethod new isStub: true.
	entity := FamixJavaMethod new.
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategyTest >> staticTag: aDictionary ofCondition: aCondition [
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategyTest >> tag: aTag ofQuery: aQuery [

	self assert: aTag name equals: aQuery name.
	self assert: aTag evaluatingObject equals: aQuery
]

{ #category : #test }
GradualTagsGenerationStrategyTest >> testCreateQueryTagFor [
	| tag |
	tag := strategy createQueryTagFor: query. 
	self tag: tag ofQuery: query 
]

{ #category : #test }
GradualTagsGenerationStrategyTest >> testGenerateCriticTags [
	| tags |
	strategy tagClass: MiCriticTag.
	strategy entities: { entity. violatingEntity }.
	tags := strategy generateCriticTags: { condition. condition2 }.
	self assert: ((tags at: 1) at: 'name') equals: 'Nb of violations = 1'.
	self assertCollection: ((tags at: 1) at: 'toTag') hasSameElements: {entity}.
	self assert: ((tags at: 2) at: 'name') equals: 'Nb of violations = 2'.
	self assertCollection: ((tags at: 2) at: 'toTag') hasSameElements: {violatingEntity}.
	
	
]

{ #category : #test }
GradualTagsGenerationStrategyTest >> testGenerateQueryTags [
	| tags |
	tags := strategy generateTags: { query. query2 }.
	self assert: tags size equals: 2.
	self tag: (tags at: 1) ofQuery: query.
	self tag: (tags at: 2) ofQuery: query2 
	 
]
