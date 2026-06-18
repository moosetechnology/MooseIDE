Class {
	#name : 'MiDeadCodeGenericRulesTest',
	#superclass : 'MiDeadCodeRuleModelAbstractTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNamingConventionRuleMethodNameJustTest [

	| entity |
	entity := self pharoMethod: 'test' inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNamingConventionRuleMethodNameNotTest [

	| entity |
	entity := self
		          pharoMethod: 'whateverFunctionality'
		          inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNamingConventionRuleMethodNameTestosterone [

	| entity |
	entity := self pharoMethod: 'testosterone' inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNamingConventionRuleNotDead [

	| entity |
	entity := self
		          pharoMethod: 'testWhateverFunctionality'
		          inClass: 'IsAClassTest'.

	self deny: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNamingConventionRuleWrongClassName [

	| entity |
	entity := self
		          pharoMethod: 'testWhateverFunctionality'
		          inClass: 'NotATestClass'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNoInvocationRuleIsDead [

	| entity |
	entity := FamixStMethod new.
	self assert: (MiDeadNoIncomingInvocationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeGenericRulesTest >> testNoInvocationRuleNotDead [

	| entity |
	entity := self pharoInvokedMethod: 'someFunctionality'.

	self deny: (MiDeadNoIncomingInvocationRule new isDead: entity)
]
