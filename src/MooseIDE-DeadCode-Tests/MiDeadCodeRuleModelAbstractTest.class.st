Class {
	#name : 'MiDeadCodeRuleModelAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeRuleModelAbstractTest >> pharoInvokedMethod: methName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStInvocation new
		sender: entity;
		candidates: { entity }.

	^ entity
]

{ #category : 'running' }
MiDeadCodeRuleModelAbstractTest >> pharoMethod: methName inClass: className [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.
	entity parentType: (FamixStClass new name: className).

	^ entity
]

{ #category : 'running' }
MiDeadCodeRuleModelAbstractTest >> setUp [

	super setUp.

	model := MiDeadCodeBrowserModel new.
	model browser: Mock new
]
