"
A CBMultipleTagsGenerationStrategyTest is a test class for testing the behavior of CBMultipleTagsGenerationStrategy
"
Class {
	#name : #MultipleTagsGenerationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy',
		'condition',
		'condition2',
		'context'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
MultipleTagsGenerationStrategyTest >> setUp [
	super setUp.
	
	strategy := MultipleTagsGenerationStrategy new
		tagClass: MiCriticTag.
	
	context := FamixCBRootContext named: 'root' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	condition2 := FamixCBCondition named: 'test2' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]')).
	context addChild: condition; addChild: condition2.
]

{ #category : #'as yet unclassified' }
MultipleTagsGenerationStrategyTest >> tag: aTag ofCondition: aCondition [

	self assert: aTag name equals: aCondition name.
	self assert: aTag description equals: aCondition summary.
	self assert: aTag evaluatingObject equals: aCondition
]

{ #category : #test }
MultipleTagsGenerationStrategyTest >> testCreateTagFor [
	| tag |
	tag := strategy createTagFor: condition. 
	self tag: tag ofCondition: condition 
	
	
	
]

{ #category : #test }
MultipleTagsGenerationStrategyTest >> testGenerateTags [
	| tags |
	tags := strategy generateTags: context getAllConditions.
	self assert: tags size equals: 2.
	self tag: (tags at: 1) ofCondition: condition.
	self tag: (tags at: 2) ofCondition: condition2 
	 
]
