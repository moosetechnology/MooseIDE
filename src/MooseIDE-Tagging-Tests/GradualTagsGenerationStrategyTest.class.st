Class {
	#name : #GradualTagsGenerationStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy',
		'query',
		'query2'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #initialization }
GradualTagsGenerationStrategyTest >> setUp [
	super setUp.
	
	strategy := GradualTagsGenerationStrategy new
		tagClass: MiQueryTag.
	
	query := FQBooleanQuery property: #isStub.
	query2 := FQBooleanQuery property: #isDead
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
