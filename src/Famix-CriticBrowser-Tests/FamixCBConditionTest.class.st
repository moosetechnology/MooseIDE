"
A FamixCBConditionTest is a test class for testing the behavior of FamixCBCondition
"
Class {
	#name : #FamixCBConditionTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #test }
FamixCBConditionTest >> testPutViolationsInto [
	| condition violatingEntity dict |
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	violatingEntity := FamixJavaMethod new. violatingEntity isStub: true.
	dict := Dictionary new.
	
	condition runOn: { violatingEntity }.
	condition putViolationsInto: dict.
	self assert: dict keys size equals: 1.
	self assert: dict keys anyOne equals: condition.
	self assert: (dict at: condition) class equals: FamixCBViolationGroup.
	self assert: (dict at: condition) size equals: 1.
	self assert: (dict at: condition) anyOne violatingEntity equals: violatingEntity
]

{ #category : #tests }
FamixCBConditionTest >> testQuery [
	self should: [ FamixCBCondition named: 'test' on: 'test' ] raise: NotAValidQuery.
	self shouldnt: [ FamixCBCondition named: 'test' on: (MiCriticBrowserPharoCodeQuery new) ] raise: NotAValidQuery
]

{ #category : #test }
FamixCBConditionTest >> testRunOn [
	| condition entity stubEntity |
	condition := FamixCBCondition named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	entity := FamixJavaMethod new.
	stubEntity := FamixJavaMethod new. stubEntity isStub: true.
	
	condition runOn: { entity. stubEntity }.
	self assert: condition violations size equals: 1.
	self assert: condition violations anyOne violatingEntity equals: stubEntity.
	self assert: condition violations anyOne violatedCondition equals: condition
]
