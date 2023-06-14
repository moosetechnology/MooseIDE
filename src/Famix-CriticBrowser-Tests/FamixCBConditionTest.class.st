"
A FamixCBConditionTest is a test class for testing the behavior of FamixCBCondition
"
Class {
	#name : #FamixCBConditionTest,
	#superclass : #TestCase,
	#instVars : [
		'condition',
		'violatingEntity',
		'violation',
		'entity'
	],
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #running }
FamixCBConditionTest >> setUp [

	super setUp.

	condition := FamixCBCondition named: 'test1' on:
		             (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]').

	violatingEntity := FamixJavaMethod new.
	violatingEntity isStub: true.

	violation := FamixCBViolation
		             condition: condition
		             violatedBy: violatingEntity.

	entity := FamixJavaMethod new
]

{ #category : #test }
FamixCBConditionTest >> testAddViolation [

	condition addViolation: (FamixCBViolation condition: condition violatedBy: violatingEntity).
	self assert: condition violations size equals: 1.
	condition addViolation: (FamixCBViolation condition: condition violatedBy: violatingEntity).
	self assert: condition violations size equals: 1.
	condition addViolation: (FamixCBViolation condition: condition violatedBy: FamixJavaClass new).
	self assert: condition violations size equals: 2.
]

{ #category : #test }
FamixCBConditionTest >> testPutViolationsInto [
	| dict |
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

	self
		should: [ FamixCBCondition named: 'test' on: 'test' ]
		raise: NotAValidQuery.
	
	self
		shouldnt: [
			FamixCBCondition
				named: 'test'
				on: MiCriticBrowserPharoCodeQuery new ]
		raise: NotAValidQuery
]

{ #category : #test }
FamixCBConditionTest >> testRemoveAllViolations [
	| violation2 violation3 violation4 |
	violation2 := FamixCBViolation condition: condition violatedBy: FamixJavaClass new.
	violation3 := FamixCBViolation condition: condition violatedBy: FamixJavaAttribute new.
	violation4 := FamixCBViolation condition: condition violatedBy: FamixJavaParameter new.

	condition removeAllViolations.
	self assert: condition violations size equals: 0
]

{ #category : #test }
FamixCBConditionTest >> testRemoveViolation [
	
	condition addViolation: violation .
	condition removeViolation: violation.
	self assert: (condition violations includes: violation) equals: false.
	self assert: (violatingEntity violations includes: violation) equals: false
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
