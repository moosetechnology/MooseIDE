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
		'entity'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
CBMultipleTagsGenerationStrategyTest >> setUp [
	super setUp.
	
	strategy := CBMultipleTagsGenerationStrategy new.
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	violatingEntity := FamixJavaMethod new. violatingEntity isStub: true.
	entity := FamixJavaMethod new.
]

{ #category : #test }
CBMultipleTagsGenerationStrategyTest >> testCreateTagFor [
	| tag |
	tag := strategy createTagFor: condition. 
	self assert: tag name equals: condition name.
	self assert: tag description equals: condition summary.
	self assert: tag rule equals: condition
	
	
	
]
