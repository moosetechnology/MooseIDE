"
A MiCBRuleTest is a test class for testing the behavior of MiCBRule
"
Class {
	#name : #FamixCBRuleTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #test }
FamixCBRuleTest >> testQuery [
	self should: [ FamixCBRule named: 'test' on: 'test' ] raise: NotAValidQuery.
	self shouldnt: [ FamixCBRule named: 'test' on: (MiCriticBrowserPharoCodeQuery new) ] raise: NotAValidQuery
]

{ #category : #test }
FamixCBRuleTest >> testRunOn [
	| rule entity stubEntity res |
	rule := FamixCBRule named: 'test1' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	entity := FamixJavaMethod new.
	stubEntity := FamixJavaMethod new. stubEntity isStub: true.
	res := rule runOn: { entity. stubEntity } asMooseGroup.
	self assert: (res class) equals: FamixCBViolationGroup.
	self assert: (res size) equals: 1.
	self assert: ((res at: 1) class) equals: FamixCBViolation.
	self assert: ((res at: 1) violatingEntity) equals: stubEntity.
	self assert: ((res at: 1) violatedRule) equals: rule
]
