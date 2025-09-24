Class {
	#name : 'FamixCBRunnerTest',
	#superclass : 'TestCase',
	#instVars : [
		'runner'
	],
	#category : 'Famix-CriticBrowser-Tests',
	#package : 'Famix-CriticBrowser-Tests'
}

{ #category : 'entities' }
FamixCBRunnerTest >> modelExample [

	| model |
	model := FamixJavaModel new.

	model newClassNamed: 'ConcreteClass'.
	(model newClassNamed: 'AbstractClas') isAbstract: true.

	^ model
]

{ #category : 'running' }
FamixCBRunnerTest >> setUp [

	super setUp.
	runner := FamixCBRunner new
]

{ #category : 'tests' }
FamixCBRunnerTest >> testAddRule [

	| rootContext context |
	runner addRule: FamixCBTestRule new.

	rootContext := runner instVarNamed: #rootContext.
	context := rootContext children anyOne.

	self assert: context isCBContext.
	self assert: context children anyOne isCBCondition
]

{ #category : 'tests' }
FamixCBRunnerTest >> testRunOn [

	| result violatingEntity |
	runner addRule: FamixCBTestRule new.

	result := runner runOn: self modelExample.

	self assert: result size equals: 1.
	violatingEntity := result anyOne violatingEntity.
	self assert: violatingEntity isClass.
	self assert: violatingEntity isAbstract
]
