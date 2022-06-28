"
A FamixCBContextTest is a test class for testing the behavior of FamixCBContext
"
Class {
	#name : #FamixCBContextTest,
	#superclass : #TestCase,
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #tests }
FamixCBContextTest >> testRunOn [
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
	context runOn: { contextEntity. entity. childContextEntity. entityInvalid }.
	self assert: context entities size equals: 2.
	self assertCollection: context entities hasSameElements: { contextEntity. childContextEntity }.
	self assert: childContext entities size equals: 1.
	self assert: childContext entities anyOne equals: childContextEntity
	
	
]
