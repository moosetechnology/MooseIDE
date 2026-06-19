Class {
	#name : 'MiDeadCodePharoRulesTest',
	#superclass : 'MiDeadCodeRuleModelAbstractTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodePharoRulesTest >> pharoClass: aClass inheritFrom: superclassName [

	FamixStInheritance new
		superclass: (FamixStClass new name: superclassName);
		subclass: aClass
]

{ #category : 'running' }
MiDeadCodePharoRulesTest >> pharoMethod: methName withPragma: annotationName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStAnnotationInstance new
		annotationType: (FamixStAnnotationType new name: annotationName);
		annotatedEntity: entity.

	^ entity
]

{ #category : 'tests - heuristics' }
MiDeadCodePharoRulesTest >> testPharoPragmaRuleIsDead [

	| entity |
	entity := self
		          pharoMethod: 'someFunctionality'
		          withPragma: 'generated'.

	self assert: (MiDeadPharoPragmasRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodePharoRulesTest >> testPharoPragmaRuleScriptNotDead [

	| entity |
	entity := self pharoMethod: 'someFunctionality' withPragma: 'script'.

	self deny: (MiDeadPharoPragmasRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodePharoRulesTest >> testPharoTestCaseRuleIsDead [

	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'Object'.

	self assert: (MiDeadPharoTestCaseSubClassRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodePharoRulesTest >> testPharoTestCaseRuleNotDead [

	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'TestCase'.

	self deny: (MiDeadPharoTestCaseSubClassRule new isDead: entity)
]
