"
A MiCriticBrowserModelTest is a test class for testing the behavior of MiCriticBrowserModel
"
Class {
	#name : #MiCriticBrowserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'stubEntity',
		'deadEntity',
		'stubCondition',
		'deadCondition'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #initialization }
MiCriticBrowserModelTest >> setUp [
	model := MiCriticBrowserModel new.
	stubCondition := FamixCBCondition named: 'test1' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]'). 
	deadCondition := FamixCBCondition named: 'test2' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]').
	model rootContext addChild: stubCondition.
	model rootContext addChild: deadCondition.
	stubEntity := FamixStMethod named: 'test1'.
	deadEntity := FamixStMethod named: 'test2'.
	stubEntity isStub: true
]

{ #category : #test }
MiCriticBrowserModelTest >> testGetAllViolations [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: model getAllViolations class equals: FamixCBViolationGroup.
	self assertCollection: model getAllViolations allEntities includesAll: { stubEntity. deadEntity }  
	
]

{ #category : #test }
MiCriticBrowserModelTest >> testRemoveRuleViolations [
	self assert: (model violations includesKey: stubCondition) equals: false.
	model setEntities: { } asMooseGroup.
	model run.
	self assert: (model violations includesKey: stubCondition) equals: true.
	model removeRuleViolations: stubCondition.
	self assert: (model violations includesKey: stubCondition) equals: false.
	
]

{ #category : #tests }
MiCriticBrowserModelTest >> testRunRules [	
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: model violations size equals: 2.
	self assertCollection: ((model violationsOf: stubCondition) allEntities) includesAll: {stubEntity}.
	self assertCollection: ((model violationsOf: deadCondition) allEntities) includesAll: { stubEntity. deadEntity }.
	
]

{ #category : #test }
MiCriticBrowserModelTest >> testSetEntities [
	| entityA entityB group |
	entityA := FamixStMethod new. 
	entityA name: 'a'.
	entityB := FamixStMethod new.
	entityB name: 'b'.
	group := MooseGroup new.
	group add: entityB; add: entityA.
	
	model setEntities: entityA.
	self assertCollection: (model entities) includesAll: {entityA}.
	self assert: model entities class equals: MooseGroup.
	
	model setEntities: group.
	self assertCollection: (model entities) includesAll: group.
	self assert: model entities class equals: group class
	
]

{ #category : #test }
MiCriticBrowserModelTest >> testSetOutput [
	| entityA |
	entityA := FamixStMethod new. 
	entityA name: 'a'.
	
	model setEntities: entityA.
	
	self assert: (model entities at:1) equals: entityA.
	self assert: model entities class equals: MooseGroup
]

{ #category : #test }
MiCriticBrowserModelTest >> testViolationsOf [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: (model violationsOf: stubCondition) class equals: FamixCBViolationGroup.
	self assertCollection: model getAllViolations allEntities includesAll: { stubEntity }
]

{ #category : #test }
MiCriticBrowserModelTest >> testViolationsOfCollection [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: (model violationsOfCollection: { stubCondition. deadCondition }) class equals: FamixCBViolationGroup.
	self assertCollection: (model violationsOfCollection: { stubCondition. deadCondition }) allEntities includesAll: { stubEntity. deadEntity }
]
