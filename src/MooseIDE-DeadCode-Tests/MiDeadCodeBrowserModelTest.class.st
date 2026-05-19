Class {
	#name : 'MiDeadCodeBrowserModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'browser'
	],
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaClass: aClass implements: anInterface [

	FamixJavaImplementation new
		implementingClass: aClass ;
		interface: anInterface
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaClass: aClass inherits: aSuperclass [

	FamixJavaInheritance new
		subclass: aClass ;
		superclass: aSuperclass 
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaClassMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaClass new).

	^entity
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaInterface new).

	^entity
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaInvokeMethod: entity [

	FamixJavaInvocation new
		sender: entity ;
		candidates: { entity }.
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaMethod: methName annotatedWith: annotationName [

	| entity |
	entity := FamixJavaMethod new.
	entity name: methName.

	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: annotationName) ;
		annotatedEntity: entity.

	^entity
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> javaParametricInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaParametricInterface new).

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> modelDeleteLines: aBoolean [

	model instVarNamed: #deleteLines put: aBoolean 
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> pharoClass: aClass inheritFrom: superclassName [

	FamixStInheritance new
		superclass: (FamixStClass new name: superclassName) ;
		subclass: aClass
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> pharoInvokedMethod: methName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStInvocation new
		sender: entity ;
		candidates: { entity }.

	^entity
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> pharoMethod: methName inClass: className [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.
	entity parentType: (FamixStClass new name: className).

	^entity
]

{ #category : 'entity creation' }
MiDeadCodeBrowserModelTest >> pharoMethod: methName withPragma: annotationName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStAnnotationInstance new
		annotationType: (FamixStAnnotationType new name: annotationName) ;
		annotatedEntity: entity.

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> setUp [
	super setUp.

	model := MiDeadCodeBrowserModel new.
	model browser: Mock new.

]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testGatherRulesList [
	"Expected number must be updated according to number of non abstract rule classes"

	self assert: model availableRules size equals: 12
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testIsNewDead [

	| entity1 entity2 entity3 |
	entity1 := self pharoMethod: 'firstLevel' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'secondLevel' inClass: 'SomeClass'.
	entity3 := self pharoMethod: 'thirdLevel' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	FamixStInvocation new
		sender: entity2 ;
		candidates: { entity3 }.
	model deadEntities add: entity1.

	self deny: (model isNewDead: entity1).
	self assert: (model isNewDead: entity2).
	self deny: (model isNewDead: entity3)

]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaAnnotationRuleDeadNoAnnotation [
	"Unused method with no annotation is dead"

	| entity |
	entity := FamixJavaMethod new.

	self assert: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaAnnotationRuleDeadWrongAnnotation [
	"Unused method with @Deprecated annotation is dead"

	| entity |
	entity := self javaMethod: 'someFunctionality' annotatedWith: 'Deprecated'.

	self assert: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaAnnotationRuleNotDead [
	"Unused method with JUnit annotation is not dead"

	| entity |
	entity := self javaMethod: 'someFunctionality' annotatedWith: 'BeforeClass'.

	self deny: (MiDeadJavaTestAnnotationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaHasOverridingRuleDead [
	"Unused method (entity1.doSomething()) with sub-method declaring @Override is not dead"

	| entity1 entity2 annotation |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.

	annotation := FamixJavaAnnotationType new name: 'Override'.
	annotation annotationTypesContainer: (FamixJavaPackage new
		name: 'lang' ;
		parentPackage: (FamixJavaPackage new
			name: 'java') ).
	FamixJavaAnnotationInstance new
		annotatedEntity: entity2 ;
		annotationType: annotation.

	self deny: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaHasOverridingRuleDeadNoAnnotation [
	"Unused method (entity1.doSomething()) with sub-method not declaring @Override is dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaHasOverridingRuleDeadNoOverride [
	"Unused method (entity1.doSomething()) with sub-method not declaring @Override is dead"

	| entity1 entity2 annotation |

	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity2 parentType inherits: entity1 parentType.


	annotation := FamixJavaAnnotationType new name: 'Deprecated'.
	annotation annotationTypesContainer: (FamixJavaPackage new
		name: 'lang' ;
		parentPackage: (FamixJavaPackage new
			name: 'java') ).

	FamixJavaAnnotationInstance new
		annotatedEntity: entity2 ;
		annotationType: annotation.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaHasOverridingRuleDeadNoSubMethod [
	"Unused method (entity1.doSomething()) with sub-method declaring @Override is dead
	 (note: entity1.doSomething() is not a sub method of entity1.doSomething()"

	| entity1 entity2 annotation |

	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.

	annotation := FamixJavaAnnotationType new name: 'Override'.
	annotation annotationTypesContainer: (FamixJavaPackage new
		name: 'lang' ;
		parentPackage: (FamixJavaPackage new
			name: 'java') ).
	FamixJavaAnnotationInstance new
		annotatedEntity: entity2 ;
		annotationType: annotation.

	self assert: (MiDeadJavaHasOverridingRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleGenericMethod [
	"Unused method (entity1.doSomething(String)) implementing a parametric interface declaration
	 should not be dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething(String)'.
	entity2 := self javaParametricInterfaceMethod: 'doSomething(T)'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleNoInterface [
	"Unused method (entity1.doSomething()) not implementing an abtract declaration is dead"

	| entity1 |
	entity1 := self javaClassMethod: 'doSomething()'.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleNoOverride [
	"Unused method (entity1.doSomething())) implementing an interface declaration is not dead
	 (according to MiDeadCodeJavaImplementsAbstractHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleNotAbstract [
	"Unused method (entity1.doSomething()) overriding a super-method is dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	self javaClass: entity1 parentType inherits: entity2 parentType.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleWithAbstract [
	"Unused method (entity1.doSomething()) overriding an abstract super-method is not dead"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	entity2 isAbstract: true.
	self javaClass: entity1 parentType inherits: entity2 parentType.

	self deny: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaImplementsRuleWithOverride [
	"Unused method (entity1.doSomething()) implementing an interface declaration but overriding a concrete implementation is dead"

	| entity1 entity2 entity3 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	entity3 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType inherits: entity2 parentType.
	self javaClass: entity1 parentType implements: entity3 parentType.

	self assert: (MiDeadJavaImplementsAbstractRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaOverridesRuleDeadNoInterface [
	"Unused method (entity1.doSomething()) is dead
	 note: no link between entity1 and entity2"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaOverridesRuleDeadNoInvocation [
	"Unused method implementing an interface declaration is dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaOverridesRuleDeadNoMethod [
	"Unused method (entity1.doSomething()) with no implementing sub-method used is dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)
	 note: methods names are different"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doOtherThing()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testJavaOverridesRuleNotDead [
	"Unused method (entity1.doSomething()) with implementing sub-method used is not dead
	 (according to MiDeadCodeJavaOverridesInvokedHeuristic)"

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self deny: (MiDeadJavaOverridesInvokedRule new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNamingConventionRuleMethodNameJustTest [

	| entity |
	entity := self pharoMethod: 'test'  inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNamingConventionRuleMethodNameNotTest [

	| entity |
	entity := self pharoMethod: 'whateverFunctionality'  inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNamingConventionRuleMethodNameTestosterone [

	| entity |
	entity := self pharoMethod: 'testosterone'  inClass: 'IsAClassTest'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNamingConventionRuleNotDead [
	| entity |
	entity := self pharoMethod: 'testWhateverFunctionality'  inClass: 'IsAClassTest'.

	self deny: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNamingConventionRuleWrongClassName [

	| entity |
	entity := self pharoMethod: 'testWhateverFunctionality'  inClass: 'NotATestClass'.

	self assert: (MiDeadTestNamingConventionRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNoInvocationRuleIsDead [

	| entity |
	entity := FamixStMethod new.
	self assert: (MiDeadNoIncomingInvocationRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNoInvocationRuleNotDead [

	| entity |
	entity := self pharoInvokedMethod: 'someFunctionality'.

	self deny: (MiDeadNoIncomingInvocationRule new isDead: entity)
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testOneRoundRecursion [

	| entity1 entity2 entity3 |
	entity1 := self pharoMethod: 'firstLevel' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'secondLevel' inClass: 'SomeClass'.
	entity3 := self pharoMethod: 'thirdLevel' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	FamixStInvocation new
		sender: entity2 ;
		candidates: { entity3 }.
	model deadEntities add: entity1.

	self assert: model deadEntities size equals: 1.
	model oneRoundRecursion.
	self assert: model deadEntities size equals: 2.
	model oneRoundRecursion.
	self assert: model deadEntities size equals: 3
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoPragmaRuleIsDead [
	| entity |

	entity := self pharoMethod: 'someFunctionality' withPragma: 'generated'.

	self assert: (MiDeadPharoPragmasRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoPragmaRuleScriptNotDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' withPragma: 'script'.

	self deny: (MiDeadPharoPragmasRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoTestCaseRuleIsDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'Object'.

	self assert: (MiDeadPharoTestCaseSubClassRule new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoTestCaseRuleNotDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'TestCase'.

	self deny: (MiDeadPharoTestCaseSubClassRule new isDead: entity)
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRecursionRoundInvokedByDead [

	| entity1 entity2 |
	entity1 := self pharoMethod: 'invoking' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'invokedFunctionality' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	model followEntity: { entity1 . entity2 }.
	model deadEntities add: entity1.

	self assert: model deadEntities size equals: 1.
	model runComputation.
	self assert: model deadEntities size equals: 2
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRecursionRoundInvokedByDeadRecursively [

	| entity1 entity2 entity3 |
	entity1 := self pharoMethod: 'firstLevel' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'secondLevel' inClass: 'SomeClass'.
	entity3 := self pharoMethod: 'thirdLevel' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	model followEntity: { entity1 . entity2 . entity3 }.
	FamixStInvocation new
		sender: entity2 ;
		candidates: { entity3 }.
	model deadEntities add: entity1.

	self assert: model deadEntities size equals: 1.
	model runComputation.
	self assert: model deadEntities size equals: 3
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRecursionRoundInvokedByNotDead [

	| entity1 entity2 |
	entity1 := self pharoMethod: 'invoking' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'invokedFunctionality' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity2 ;
		candidates: { entity2 }.
	model followEntity: { entity1 . entity2 }.
	model deadEntities add: entity1.

	self assert: model deadEntities size equals: 1.
	model runComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRecursionRoundNotAddingOutsideFollwedEntities [

	| entity1 entity2 entity3 |
	entity1 := self pharoMethod: 'firstLevel' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'secondLevel' inClass: 'SomeClass'.
	entity3 := self pharoMethod: 'thirdLevel' inClass: 'SomeClass'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	model followEntity: { entity1 . entity2 }.
	FamixStInvocation new
		sender: entity2 ;
		candidates: { entity3 }.
	model deadEntities add: entity1.

	self assert: model deadEntities size equals: 1.
	model runComputation.
	self assert: model deadEntities size equals: 2
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRecursionRoundProtectedByHeursitic [

	| entity1 entity2 |
	entity1 := self pharoMethod: 'invoking' inClass: 'SomeClass'.
	entity2 := self pharoMethod: 'testSomething'  inClass: 'IsAClassTest'.
	FamixStInvocation new
		sender: entity1 ;
		candidates: { entity2 }.
	model followEntity: { entity1 . entity2 }.
	model deadEntities add: entity1.
	model chooseRules: { MiDeadTestNamingConventionRule new }.

	self assert: model deadEntities size equals: 1.
	model runComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRefactorCommentsCode [
	"Refactoring works on files and uses sourceAnchor-s
	 Therefore we have to create all this"

	| mooseModel mth actual expected |
	mooseModel := FamixStModel new.

	mooseModel rootFolder: FileSystem memory root.
	(mooseModel rootFolder / 'fakefile')
		ensureCreateFile;
		writeStreamDo: [ :s | s << '123
abc
456' ].

	mth := FamixStMethod new.
	mth mooseModel: mooseModel.
	FamixJavaIndexedFileAnchor new
		startPos: 5 ;
		endPos: 7 ;
		fileName: 'fakefile' ;
		element: mth.
	model deadEntities add: mth.

	self modelDeleteLines: false.
	
	model refactorCode.

	actual := (mooseModel rootFolder / 'fakefile') contents withLineEndings: String cr.
	expected := '123
/* --- dead code removal ---
abc
 --- dead code removal --- */
456' withLineEndings: String cr.

	self assert: actual equals: expected
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRefactorDeleteCode [
	"Refactoring works on files and uses sourceAnchor-s
	 Therefore we have to create all this"

	| mooseModel mth actual expected |
	mooseModel := FamixStModel new.

	mooseModel rootFolder: FileSystem memory root.
	(mooseModel rootFolder / 'fakefile')
		ensureCreateFile;
		writeStreamDo: [ :s | s << '123
abc
456' ].

	mth := FamixStMethod new.
	mth mooseModel: mooseModel.
	FamixJavaIndexedFileAnchor new
		startPos: 5 ;
		endPos: 7 ;
		fileName: 'fakefile' ;
		element: mth.
	model deadEntities add: mth.

	self modelDeleteLines: true.
	
	model refactorCode.

	actual := (mooseModel rootFolder / 'fakefile') contents withLineEndings: String cr.
	expected := '123
456' withLineEndings: String cr.

	self assert: actual equals: expected
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRunDeadNotRefuted [

	model initializeRules.
	model chooseRules: { MiDeadTestNamingConventionRule new }.

	model followEntity: { self pharoMethod: 'whateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model runComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRunNoDead [

	model followEntity: { self pharoInvokedMethod: 'someFunctionality' }.

	self assert: model deadEntities size equals: 0.
	model runComputation.
	self assert: model deadEntities size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRunOneDead [

	model followEntity: { FamixStMethod new }.

	self assert: model deadEntities size equals: 0.
	model runComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testRunRefutedDead [
	"entity is not invoked, but it should be considered a test method"

	model chooseRules: { MiDeadTestNamingConventionRule new }.

	model followEntity: { self pharoMethod: 'testWhateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model runComputation.
	self assert: model deadEntities size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testSortRules [

	model chooseRules: {
		MiDeadJavaImplementsAbstractRule new .
		MiDeadJavaTestAnnotationRule new }.

	self assert: model chosenRules size equals: 3.
	self assert: model chosenRules first  class equals: MiDeadJavaImplementsAbstractRule.
	self assert: model chosenRules second class equals: MiDeadJavaTestAnnotationRule.
	self assert: model chosenRules third  class equals: MiDeadNoIncomingInvocationRule.
]
