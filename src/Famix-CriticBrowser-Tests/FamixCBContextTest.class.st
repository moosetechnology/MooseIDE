"
A FamixCBContextTest is a test class for testing the behavior of FamixCBContext
"
Class {
	#name : #FamixCBContextTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #test }
FamixCBContextTest >> testAddChild [
	| context condition childContext |
	context := FamixCBContext named: 'context' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'Condition root' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity name = ''violation'' ]').
	childContext := FamixCBContext named: 'child context' on: '[ :col | col select: [ :el | el isClass ] ]'.
	
	context addChild: condition; addChild: childContext.
	self assert: context children size equals: 2.
	self assertCollection: context children hasSameElements: { condition. childContext }.
	self assert: condition parent equals: context.
	self assert: childContext parent equals: context
]

{ #category : #test }
FamixCBContextTest >> testPutViolationsInto [
	| entity entityViolating context condition violations |
	
	entity := FamixJavaParameter new.
	entityViolating := FamixJavaParameter new.
	entity name: 'valide'.
	entityViolating name: 'violation'.
	
	context := FamixCBContext named: 'context' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'Condition root' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity name = ''violation'' ]').
	context addChild: condition.
	
	violations := Dictionary new.
	context runOnTree: { entity. entityViolating }.
	context putViolationsInto: violations.
	
	self assertCollection: violations keys hasSameElements: { condition. }.
	self assert: (violations at: condition) size equals: 1.
	self assert: (violations at: condition) anyOne violatingEntity equals: entityViolating.
]

{ #category : #test }
FamixCBContextTest >> testRemoveChild [
	| context condition childContext |
	context := FamixCBContext named: 'context' on: '[ :col | col ]'.
	condition := FamixCBCondition named: 'Condition root' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity name = ''violation'' ]').
	childContext := FamixCBContext named: 'child context' on: '[ :col | col select: [ :el | el isClass ] ]'.
	
	context addChild: condition; addChild: childContext.
	self assert: context children size equals: 2.
	context removeChild: condition.
	self assert: context children size equals: 1.
	self assert: context children anyOne equals: childContext.
	self assert: condition parent equals: nil
]

{ #category : #tests }
FamixCBContextTest >> testRunOn [
	| contextEntity entity context |
	contextEntity := FamixJavaClass new.
	entity := FamixJavaParameter new.
	
	entity name: 'invalide'.
	contextEntity name: 'Invalide'.
	
	context := FamixCBContext new.
	context contextBlock: '[ :col | col select: [ :el | el isClass ] ]'.
	
	context runOn: { contextEntity. entity. }.
	self assert: context entities size equals: 1.
	self assert: context entities anyOne equals: contextEntity.
	
	
]

{ #category : #tests }
FamixCBContextTest >> testRunOnTree [
	| contextEntity childContextEntity entity entityInvalid context childContext |
	contextEntity := FamixJavaClass new.
	childContextEntity := FamixJavaClass new.
	entity := FamixJavaParameter new.
	entityInvalid := FamixJavaParameter new.
	
	entity name: 'invalide'.
	contextEntity name: 'Invalide'.
	childContextEntity name: 'ValideContexte'.
	entityInvalid name: 'invalideMaisContexte'.
	
	context := FamixCBContext new.
	context contextBlock: '[ :col | col select: [ :el | el isClass ] ]'.
	
	childContext := FamixCBContext new.
	childContext contextBlock: '[ :col | col select: [ :el | el name endsWith: ''Contexte'' ] ]'.
	
	context addChild: childContext.
	context runOnTree: { contextEntity. entity. childContextEntity. entityInvalid }.
	self assert: context entities size equals: 2.
	self assertCollection: context entities hasSameElements: { contextEntity. childContextEntity }.
	self assert: childContext entities size equals: 1.
	self assert: childContext entities anyOne equals: childContextEntity
	
	
]
