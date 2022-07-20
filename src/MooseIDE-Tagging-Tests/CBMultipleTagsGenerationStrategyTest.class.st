"
A CBMultipleTagsGenerationStrategyTest is a test class for testing the behavior of CBMultipleTagsGenerationStrategy
"
Class {
	#name : #CBMultipleTagsGenerationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy',
		'condition',
		'violatingEntity',
		'entity',
		'condition2',
		'context'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
CBMultipleTagsGenerationStrategyTest >> setUp [
	super setUp.
	
	strategy := CBMultipleTagsGenerationStrategy new.
	
	context := FamixCBRootContext named: 'root' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	condition2 := FamixCBCondition named: 'test2' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]')).
	context addChild: condition; addChild: condition2.
	
	violatingEntity := FamixJavaMethod new. violatingEntity isStub: true.
	entity := FamixJavaMethod new.
]

{ #category : #'as yet unclassified' }
CBMultipleTagsGenerationStrategyTest >> tag: aTag ofCondition: aCondition [

	self assert: aTag name equals: aCondition name.
	self assert: aTag description equals: aCondition summary.
	self assert: aTag rule equals: aCondition
]

{ #category : #test }
CBMultipleTagsGenerationStrategyTest >> testCreateTagFor [
	| tag |
	tag := strategy createTagFor: condition. 
	self tag: tag ofCondition: condition 
	
	
	
]

{ #category : #test }
CBMultipleTagsGenerationStrategyTest >> testGenerateTags [
	| tags |
	tags := strategy generateTags: context.
	self assert: tags size equals: 2.
	self tag: (tags at: 1) ofCondition: condition.
	self tag: (tags at: 2) ofCondition: condition2 
	 
]
