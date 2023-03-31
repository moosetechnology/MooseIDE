"
A FamixCBViolationTest is a test class for testing the behavior of FamixCBViolation
"
Class {
	#name : #FamixCBViolationTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #test }
FamixCBViolationTest >> testEqualsSign [
	| violation entity condition |
	entity := FamixJavaClass new.
	condition := FamixCBCondition new.
	violation := FamixCBViolation condition: condition violatedBy: entity. 
	self assert: violation = 2 equals: false.
	self assert: violation = (FamixCBViolation condition: FamixCBCondition new violatedBy: entity) equals: false.
	self assert: violation = (FamixCBViolation condition: condition violatedBy: FamixJavaClass new) equals: false.
	self assert: violation = (FamixCBViolation condition: condition violatedBy: entity) equals: true
]
