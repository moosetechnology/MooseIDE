"
An OneTagGenerationStrategyTest is a test class for testing the behavior of OneTagGenerationStrategy
"
Class {
	#name : #OneTagGenerationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'stubEntity',
		'entity',
		'strategy',
		'query',
		'query2',
		'context',
		'condition',
		'condition2'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #initialization }
OneTagGenerationStrategyTest >> setUp [

	super setUp.

	stubEntity := FamixJavaMethod new isStub: true.
	entity := FamixJavaMethod new.

	strategy := OneTagGenerationStrategy new
		            entities: { 
				            entity.
				            stubEntity };
		            tagClass: MiQueryTag.

	query := FQBooleanQuery property: #isStub.
	query2 := FQBooleanQuery property: #isDead.

	context := FamixCBRootContext named: 'root' on: '[ :col | col ]'.
	condition := FamixCBCondition
		             named: 'test1'
		             on:
		             (MiCriticBrowserPharoCodeQuery on:
			              '[ :entity | entity isStub ]').
	condition2 := FamixCBCondition
		              named: 'test2'
		              on:
		              (MiCriticBrowserPharoCodeQuery on:
			               '[ :entity | entity isDead ]').
	context
		addChild: condition;
		addChild: condition2
]

{ #category : #tests }
OneTagGenerationStrategyTest >> testGenerateCriticTag [
	| tag |
	strategy tagClass: MiCriticTag.
	tag := (strategy generateTags: { condition. condition2 }) first.
	self assert: (tag at: 'name') equals: 'Violations'.
	self assertCollection: (tag at: 'toTag') hasSameElements: { stubEntity. entity }.
]

{ #category : #tests }
OneTagGenerationStrategyTest >> testGenerateQueryTag [
	| tag |
	tag := (strategy generateTags: { query. query2 }) first.
	self assert: (tag at: 'name') equals: 'Queried entities'.
	self assertCollection: (tag at: 'toTag') hasSameElements: { stubEntity. entity }.
]
