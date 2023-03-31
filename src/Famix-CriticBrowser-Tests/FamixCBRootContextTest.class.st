"
A FamixCBRootContextTest is a test class for testing the behavior of FamixCBRootContext
"
Class {
	#name : #FamixCBRootContextTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #test }
FamixCBRootContextTest >> testGetAllViolations [
	| contextEntity childEntityViolating entity entityViolating rootContext childContext condition childCondition violations |
	contextEntity := FamixJavaClass new.
	childEntityViolating := FamixJavaClass new.
	entity := FamixJavaParameter new.
	entityViolating := FamixJavaParameter new.
	
	entity name: 'invalide'.
	contextEntity name: 'Invalide'.
	childEntityViolating name: 'Violation'.
	entityViolating name: 'violation'.
	
	rootContext := FamixCBRootContext new.
	rootContext contextBlock: '[ :col | col ]'.
	
	childContext := FamixCBContext named: 'Child of Root' on: '[ :col | col select: [ :el | el isClass ] ]'.
	
	condition := FamixCBCondition named: 'Condition root' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | (entity class = FamixJavaParameter) and: [ entity name = ''violation'' ] ]').
	
	childCondition := FamixCBCondition named: 'Condition child' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isClass and: [ entity name = ''Violation'' ] ]').
	
	rootContext addChild: childContext.
	rootContext addChild: condition.
	childContext addChild: childCondition.
	rootContext runDownTree: { contextEntity. entity. childEntityViolating. entityViolating }.
	violations := rootContext getAllViolations.
	self assert: violations class equals: Dictionary.
	self assertCollection: violations keys hasSameElements: { condition. childCondition }.
	self assert: (violations at: condition) size equals: 1.
	self assert: (violations at: condition) anyOne violatingEntity equals: entityViolating.
	self assert: (violations at: childCondition) size equals: 1.
	self assert: (violations at: childCondition) anyOne violatingEntity equals: childEntityViolating.
	
]
