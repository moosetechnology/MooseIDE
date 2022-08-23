"
A MiCBViolationGroupTest is a test class for testing the behavior of MiCBViolationGroup
"
Class {
	#name : #FamixCBViolationGroupTest,
	#superclass : #TestCase,
	#instVars : [
		'violation1',
		'violation2',
		'group',
		'rule'
	],
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #initialization }
FamixCBViolationGroupTest >> setUp [
	rule := FamixCBCondition named: 'test' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | true ]').
	violation1 := FamixCBViolation condition: rule violatedBy: FamixJavaMethod new.
	violation2 := FamixCBViolation condition: rule violatedBy: FamixJavaAttribute new.
	group := { violation1. violation2 } asMooseGroup specialize.
]

{ #category : #test }
FamixCBViolationGroupTest >> testAllViolatingEntitiesType [
	self assertCollection: group allViolatingEntitiesType includesAll: { FamixJavaMethod. FamixJavaAttribute }
]

{ #category : #test }
FamixCBViolationGroupTest >> testAllWithViolatingEntitiesType [
	self assert: (group allWithViolatingEntitiesType: FamixJavaMethod) size equals: 1.
	self assertCollection: (group allWithViolatingEntitiesType: FamixJavaMethod) includesAll: { violation1 }.
	self assert: (group allWithViolatingEntitiesType: FamixJavaAttribute) size equals: 1.
	self assertCollection: (group allWithViolatingEntitiesType: FamixJavaAttribute) includesAll: { violation2 }.
]
