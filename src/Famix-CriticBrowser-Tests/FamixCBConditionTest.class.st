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

	condition := FamixCBCondition
		             named: 'test1'
		             on:
		             (FamixCBScriptQueryHandler on:
			              '[ :entity | entity isStub ]').

	violatingEntity := FamixJavaMethod new.
	violatingEntity isStub: true.

	violation := FamixCBViolation
		             condition: condition
		             violatedBy: violatingEntity.

	entity := FamixJavaMethod new
]

{ #category : #tests }
FamixCBConditionTest >> testAddViolation [

	condition addViolation: (FamixCBViolation condition: condition violatedBy: violatingEntity).
	self assert: condition violations size equals: 1.
	condition addViolation: (FamixCBViolation condition: condition violatedBy: violatingEntity).
	self assert: condition violations size equals: 1.
	condition addViolation: (FamixCBViolation condition: condition violatedBy: FamixJavaClass new).
	self assert: condition violations size equals: 2.
]

{ #category : #tests }
FamixCBConditionTest >> testAllParents [

	| parent1 parent2 |
	parent1 := FamixCBContext new.
	parent2 := FamixCBContext new.

	self assertEmpty: condition allParents.
	condition parent: parent1.
	parent1 parent: parent2.

	self assertCollection: condition allParents hasSameElements: {
			parent1.
			parent2 }.
	self
		assertCollection: parent1 allParents
		hasSameElements: { parent2 }
]

{ #category : #tests }
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
		raise: FamixCBNotAValidQuery.
	
	self
		shouldnt: [
			FamixCBCondition
				named: 'test'
				on: FamixCBQueryHandler new ]
		raise: FamixCBNotAValidQuery
]

{ #category : #tests }
FamixCBConditionTest >> testRemoveAllViolations [
	| violation2 violation3 violation4 |
	violation2 := FamixCBViolation condition: condition violatedBy: FamixJavaClass new.
	violation3 := FamixCBViolation condition: condition violatedBy: FamixJavaAttribute new.
	violation4 := FamixCBViolation condition: condition violatedBy: FamixJavaParameter new.

	condition removeAllViolations.
	self assert: condition violations size equals: 0
]

{ #category : #tests }
FamixCBConditionTest >> testRemoveViolation [
	
	condition addViolation: violation .
	condition removeViolation: violation.
	self assert: (condition violations includes: violation) equals: false.
	self assert: (violatingEntity violations includes: violation) equals: false
]

{ #category : #tests }
FamixCBConditionTest >> testRunOn [

	| stubEntity |
	condition := FamixCBCondition
		             named: 'test1'
		             on:
		             (FamixCBScriptQueryHandler on:
			              '[ :entity | entity isStub ]').
	entity := FamixJavaMethod new.
	stubEntity := FamixJavaMethod new.
	stubEntity isStub: true.

	condition runOn: {
			entity.
			stubEntity }.
	self assert: condition violations size equals: 1.
	self
		assert: condition violations anyOne violatingEntity
		equals: stubEntity.
	self
		assert: condition violations anyOne violatedCondition
		equals: condition
]
