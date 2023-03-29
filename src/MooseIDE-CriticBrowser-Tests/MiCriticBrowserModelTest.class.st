"
A MiCriticBrowserModelTest is a test class for testing the behavior of MiCriticBrowserModel
"
Class {
	#name : #MiCriticBrowserModelTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'model',
		'stubEntity',
		'deadEntity',
		'stubCondition',
		'deadCondition'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCriticBrowserModelTest >> browserClass [
	^ MiCriticBrowser
]

{ #category : #removing }
MiCriticBrowserModelTest >> removeAllFromRootContext [

	[ model rootContext children isNotEmpty ] whileTrue: [ model removeChild: model rootContext children anyOne fromContext: model rootContext ].
]

{ #category : #initialization }
MiCriticBrowserModelTest >> setUp [
	super setUp.

	model := browser model.
	stubCondition := FamixCBCondition named: 'test1' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]'). 
	deadCondition := FamixCBCondition named: 'test2' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]').
	model addChild: stubCondition toContext: model rootContext.
	model addChild: deadCondition toContext: model rootContext.
	stubEntity := FamixStMethod named: 'test1'.
	deadEntity := FamixStMethod named: 'test2'.
	stubEntity isStub: true
]

{ #category : #tests }
MiCriticBrowserModelTest >> testAddChildToContext [

	self removeAllFromRootContext.
	model addChild: stubCondition toContext: model rootContext. 
	self assert: model ruleComponents size equals: 1.
	self assert: model ruleComponents anyOne equals: stubCondition.
	self assert: model rootContext children anyOne equals: stubCondition
	
]

{ #category : #test }
MiCriticBrowserModelTest >> testAddViolationsFor [
	
	self assert: model violations keys size equals: 0.
	stubCondition runOn: { stubEntity. deadEntity }.
	model addViolationsFor: stubCondition.
	self assert: model violations keys size equals: 1.
	self assert: model violations keys anyOne equals: stubCondition
]

{ #category : #test }
MiCriticBrowserModelTest >> testContextOf [
	| classes methods classEntity |
	classes := FamixCBContext named: 'Classes' on: '[ :col | col allClasses ]'.
	methods := FamixCBContext named: 'Methods' on: '[ :col | col allMethods ]'.
	model addChild: classes toContext: model rootContext.
	model addChild: methods toContext: model rootContext.
	model addChild: stubCondition toContext: methods.
	
	classEntity := FamixJavaClass named: 'Test'. 
	model setEntities: { stubEntity. deadEntity. classEntity } asMooseGroup.
	model run.
	self assertCollection: (model contextOf: model rootContext) hasSameElements: model entities.
	self assertCollection: (model contextOf: classes) hasSameElements: { classEntity }.
	self assertCollection: (model contextOf: stubCondition) hasSameElements: { stubEntity. deadEntity }.
]

{ #category : #tests }
MiCriticBrowserModelTest >> testCreateHierarchyTree [
	| context tree |
	self removeAllFromRootContext.
	context := FamixCBContext named: 'child context' on: '[ :col | col allClasses ]'. 
	model addChild: stubCondition toContext: model rootContext.
	model addChild: context toContext: model rootContext.
	model addChild: deadCondition toContext: context.
	tree := model createHierarchyTree.
	self assert: tree size equals: 3.
	self assert: tree equals: { 0. 0. 2 } asOrderedCollection
]

{ #category : #tests }
MiCriticBrowserModelTest >> testDeleteRuleComponent [
	self assert: model rootContext children size equals: 2.
	model deleteRuleComponent: stubCondition.
	self assert: model rootContext children size equals: 1.
	self assert: model rootContext children anyOne equals: deadCondition
]

{ #category : #tests }
MiCriticBrowserModelTest >> testGetAllViolations [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: model getAllViolations class equals: FamixCBViolationGroup.
	self assertCollection: model getAllViolations allEntities includesAll: { stubEntity. deadEntity }  
	
]

{ #category : #tests }
MiCriticBrowserModelTest >> testHasBeenEdited [

	model setEntities: { stubEntity } asMooseGroup.
	model run.
	self assert: (model violations includesKey: stubCondition) equals: true.
	self assert: model rootContext children anyOne name equals: 'test1'.
	
	stubCondition name: 'test édité'.
	model hasBeenEdited: stubCondition.
	self assert: (model violations includesKey: stubCondition) equals: false.
	self assert: model rootContext children anyOne name equals: 'test édité'
]

{ #category : #test }
MiCriticBrowserModelTest >> testRemoveBranchFromRuleComponents [

	| context tree |
	self removeAllFromRootContext.
	context := FamixCBContext named: 'child context' on: '[ :col | col allClasses ]'.
	model addChild: stubCondition toContext: model rootContext.
	model addChild: context toContext: model rootContext.
	model addChild: deadCondition toContext: context.
	self assert: model ruleComponents size equals: 3.
	model removeBranchFromRuleComponents: context.
	self assert: model ruleComponents size equals: 1.
	self assert: model ruleComponents anyOne equals: stubCondition
]

{ #category : #tests }
MiCriticBrowserModelTest >> testRemoveChildFromContext [

	model removeChild: stubCondition fromContext: model rootContext.
	self assert: model ruleComponents size equals: 1.
	self assert: model rootContext children size equals: 1.
	self assert: model rootContext children anyOne equals: deadCondition.
]

{ #category : #tests }
MiCriticBrowserModelTest >> testRemoveRuleViolations [
	self assert: (model violations includesKey: stubCondition) equals: false.
	model setEntities: { } asMooseGroup.
	model run.
	self assert: (model violations includesKey: stubCondition) equals: true.
	model removeRuleViolations: stubCondition.
	self assert: (model violations includesKey: stubCondition) equals: false.
	
]

{ #category : #tests }
MiCriticBrowserModelTest >> testRun [	
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: model violations size equals: 2.
	self assertCollection: ((model violationsOf: stubCondition) allEntities) includesAll: {stubEntity}.
	self assertCollection: ((model violationsOf: deadCondition) allEntities) includesAll: { stubEntity. deadEntity }.
	
]

{ #category : #test }
MiCriticBrowserModelTest >> testRunCondition [
	
	self assert: model violations keys size equals: 0.
	model runCondition: stubCondition.
	self assert: model violations keys size equals: 1.
	self assert: model violations keys anyOne equals: stubCondition
]

{ #category : #'tests - tags' }
MiCriticBrowserModelTest >> testSelectedTagSetAndGet [
	"already tested in MiCriticBrowserTest"
	self skip
]

{ #category : #tests }
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

{ #category : #tests }
MiCriticBrowserModelTest >> testSetOutput [
	| entityA |
	entityA := FamixStMethod new. 
	entityA name: 'a'.
	
	model setEntities: entityA.
	
	self assert: (model entities at:1) equals: entityA.
	self assert: model entities class equals: MooseGroup
]

{ #category : #tests }
MiCriticBrowserModelTest >> testViolationsOf [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: (model violationsOf: stubCondition) class equals: FamixCBViolationGroup.
	self assertCollection: (model violationsOf: stubCondition) allEntities hasSameElements: { stubEntity }
]

{ #category : #tests }
MiCriticBrowserModelTest >> testViolationsOfCollection [
	model setEntities: { stubEntity. deadEntity } asMooseGroup.
	model run.
	self assert: (model violationsOfCollection: { stubCondition. deadCondition }) class equals: FamixCBViolationGroup.
	self assertCollection: (model violationsOfCollection: { stubCondition. deadCondition }) allEntities includesAll: { stubEntity. deadEntity }
]
