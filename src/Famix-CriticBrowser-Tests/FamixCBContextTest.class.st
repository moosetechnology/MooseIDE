"
A FamixCBContextTest is a test class for testing the behavior of FamixCBContext
"
Class {
	#name : #FamixCBContextTest,
	#superclass : #TestCase,
	#instVars : [
		'contextEntity',
		'childContextEntity',
		'entity',
		'entityInvalid',
		'context',
		'childContext',
		'condition',
		'violatingEntity'
	],
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #running }
FamixCBContextTest >> setUp [

	super setUp.

	contextEntity := FamixJavaClass new.
	childContextEntity := FamixJavaClass new.
	entity := FamixJavaParameter new.
	entityInvalid := FamixJavaParameter new.
	violatingEntity := FamixJavaClass new.

	entity name: 'invalide'.
	contextEntity name: 'Invalide'.
	childContextEntity name: 'ValideContexte'.
	entityInvalid name: 'invalideMaisContexte'.
	violatingEntity name: 'Violation'.

	context := FamixCBContext
		           named: 'Classes'
		           on: '[ :col | col select: [ :el | el isClass ] ]'.
	childContext := FamixCBContext
		                named: 'Suffixe Contexte'
		                on:
		                '[ :col | col select: [ :el | el name endsWith: ''Contexte'' ] ]'.
	condition := FamixCBCondition
		             named: 'Condition classes'
		             on: (FamixCBScriptQueryHandler on:
				              '[ :entity | entity name = ''Violation'' ]')
]

{ #category : #tests }
FamixCBContextTest >> testAddChild [

	context := FamixCBContext named: 'context' on: '[ :col | col ]'.
	condition := FamixCBCondition
		             named: 'Condition root'
		             on: (FamixCBQueryHandler on:
				              '[ :entity | entity name = ''violation'' ]').
	childContext := FamixCBContext
		                named: 'child context'
		                on: '[ :col | col select: [ :el | el isClass ] ]'.

	context
		addChild: condition;
		addChild: childContext.
	self assert: context children size equals: 2.
	self assertCollection: context children hasSameElements: {
			condition.
			childContext }.
	self assert: condition parent equals: context.
	self assert: childContext parent equals: context
]

{ #category : #tests }
FamixCBContextTest >> testAllParents [

	| parent1 parent2 |
	parent1 := FamixCBContext new.
	parent2 := FamixCBContext new.

	self assertEmpty: context allParents.
	context parent: parent1.
	parent1 parent: parent2.

	self assertCollection: context allParents hasSameElements: {
			parent1.
			parent2 }.
	self
		assertCollection: parent1 allParents
		hasSameElements: { parent2 }
]

{ #category : #tests }
FamixCBContextTest >> testCustomContextFilter [

	| customFilterClass customCondition |
	customFilterClass := FamixCBContextFilter newAnonymousSubclass
		                     compile: 'value: aCollection
	^ aCollection select: #isType 
';
		                     yourself.

	customCondition := FamixCBContext new contextFilter:
		                   customFilterClass new.
	customCondition runOn: {
			contextEntity.
			childContextEntity.
			entity }.

	self assertCollection: customCondition entities hasSameElements: {
			contextEntity.
			childContextEntity }
]

{ #category : #tests }
FamixCBContextTest >> testPutViolationsInto [
	| violations |
	
	violations := Dictionary new.
	context addChild: condition.
	context runDownTree: { entity. violatingEntity } withCallback: [ :e ].
	context putViolationsInto: violations.
	
	self assertCollection: violations keys hasSameElements: { condition. }.
	self assert: (violations at: condition) size equals: 1.
	self assert: (violations at: condition) anyOne violatingEntity equals: violatingEntity.
]

{ #category : #tests }
FamixCBContextTest >> testRemoveChild [
	
	context addChild: condition; addChild: childContext.
	self assert: context children size equals: 2.
	context removeChild: condition.
	self assert: context children size equals: 1.
	self assert: context children anyOne equals: childContext.
	self assert: condition parent equals: nil
]

{ #category : #tests }
FamixCBContextTest >> testResetExecutionOfTree [
	
	context addChild: childContext.
	childContext addChild: condition.
	condition addViolation: (FamixCBViolation condition: condition violatedBy: violatingEntity).
	self assert: condition violations size equals: 1.
	self assert: condition violations anyOne violatingEntity equals: violatingEntity.
	context resetExecutionOfTree.
	self assert: condition violations size equals: 0.
	self assert: context entities isEmpty equals: true.
	self assert: childContext entities isEmpty equals: true
]

{ #category : #tests }
FamixCBContextTest >> testRunDownTreeWithCallback [
	context addChild: childContext.
	context runDownTree: { contextEntity. entity. childContextEntity. entityInvalid }
		withCallback: [ :e ].

	self assert: context entities size equals: 2.
	self assertCollection: context entities hasSameElements: { contextEntity. childContextEntity }.

	self assert: childContext entities size equals: 1.
	self assert: childContext entities anyOne equals: childContextEntity
	
	
]

{ #category : #tests }
FamixCBContextTest >> testRunOn [
	
	context runOn: { contextEntity. entity. }.
	self assert: context entities size equals: 1.
	self assert: context entities anyOne equals: contextEntity.
	
	
]

{ #category : #tests }
FamixCBContextTest >> testRunUpTree [
	| rootContext |
	rootContext := FamixCBRootContext named: 'test' on: '[ :col | col ]'.
	rootContext addChild: context.
	context addChild: condition.
	
	condition runUpTree: { contextEntity. violatingEntity. entity } asMooseGroup specialize.
	self assert: condition violations size equals: 1.
	self assert: condition violations anyOne violatingEntity equals: violatingEntity.
	self assert: condition violations anyOne violatedCondition equals: condition
]
