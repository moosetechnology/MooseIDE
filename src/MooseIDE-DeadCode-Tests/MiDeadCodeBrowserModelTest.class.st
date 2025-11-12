Class {
	#name : 'MiDeadCodeBrowserModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaClass: aClass implements: anInterface [

	FamixJavaImplementation new
		implementingClass: aClass ;
		interface: anInterface
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaClass: aClass inherits: aSuperclass [

	FamixJavaInheritance new
		subclass: aClass ;
		superclass: aSuperclass 
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaClassMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaClass new).

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaInterface new).

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaInvokeMethod: entity [

	FamixJavaInvocation new
		sender: entity ;
		candidates: { entity }.
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> javaMethod: methName annotatedWith: annotationName [

	| entity |
	entity := FamixJavaMethod new.
	entity name: methName.

	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: annotationName) ;
		annotatedEntity: entity.

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> pharoClass: aClass inheritFrom: superclassName [

	FamixStInheritance new
		superclass: (FamixStClass new name: superclassName) ;
		subclass: aClass
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> pharoInvokedMethod: methName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStInvocation new
		sender: entity ;
		candidates: { entity }.

	^entity
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> pharoMethod: methName inClass: className [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.
	entity parentType: (FamixStClass new name: className).

	^entity
]

{ #category : 'running' }
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
MiDeadCodeBrowserModelTest >> testFirstRoundDeadNotRefuted [

	model initializeHeuristics.
	model chooseHeuristics: { MiDeadCodeNamingConventionHeuristic new }.

	model followEntity: { self pharoMethod: 'whateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testFirstRoundNoDead [

	model followEntity: { self pharoInvokedMethod: 'someFunctionality' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testFirstRoundOneDead [

	model followEntity: { FamixStMethod new }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testFirstRoundRefutedDead [
	"entity is not invoked, but it should be considered a test method"

	model chooseHeuristics: { MiDeadCodeNamingConventionHeuristic new }.

	model followEntity: { self pharoMethod: 'testWhateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testGatherHeuristicsList [
	"Expected number must be updated according to number of non abstract heuristics classes"

	self assert: model availableHeuristics size equals: 9
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
MiDeadCodeBrowserModelTest >> testNoInvocationHeuristicIsDead [

	| entity |
	entity := FamixStMethod new.
	self assert: (MiDeadCodeNoIncomingInvocationHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testNoInvocationHeuristicNotDead [

	| entity |
	entity := self pharoInvokedMethod: 'someFunctionality'.

	self deny: (MiDeadCodeNoIncomingInvocationHeuristic new isDead: entity)
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
MiDeadCodeBrowserModelTest >> testPharoPragmaHeuristicIsDead [
	| entity |

	entity := self pharoMethod: 'someFunctionality' withPragma: 'generated'.

	self assert: (MiDeadCodePharoPragmasHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoPragmaHeuristicScriptNotDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' withPragma: 'script'.

	self deny: (MiDeadCodePharoPragmasHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicIsDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'Object'.

	self assert: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicNotDead [
	| entity |
	entity := self pharoMethod: 'someFunctionality' inClass: 'SomeClass'.
	self pharoClass: entity parentType inheritFrom: 'TestCase'.

	self deny: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
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
	model recursionComputation.
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
	model recursionComputation.
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
	model recursionComputation.
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
	model recursionComputation.
	self assert: model deadEntities size equals: 2
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testSortHeuristics [

	model chooseHeuristics: {
		MiDeadCodeJavaImplementsInterfaceHeuristic new .
		MiDeadCodeJavaTestAnnotationHeuristic new }.

	self assert: model chosenHeuristics size equals: 3.
	self assert: model chosenHeuristics first  class equals: MiDeadCodeJavaImplementsInterfaceHeuristic.
	self assert: model chosenHeuristics second class equals: MiDeadCodeJavaTestAnnotationHeuristic.
	self assert: model chosenHeuristics third  class equals: MiDeadCodeNoIncomingInvocationHeuristic.
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicDeadNoAnnotation [

	| entity |
	entity := FamixJavaMethod new.

	self assert: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicDeadWrongAnnotation [

	| entity |
	entity := self javaMethod: 'someFunctionality' annotatedWith: 'Deprecated'.

	self assert: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicNotDead [

	| entity |
	entity := self javaMethod: 'someFunctionality' annotatedWith: 'BeforeClass'.

	self deny: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaImplementsHeuristicNoInterface [

	| entity1 |
	entity1 := self javaClassMethod: 'doSomething()'.

	self assert: (MiDeadCodeJavaImplementsInterfaceHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaImplementsHeuristicNoOverride [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self deny: (MiDeadCodeJavaImplementsInterfaceHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaImplementsHeuristicWithOverride [

	| entity1 entity2 entity3 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaClassMethod: 'doSomething()'.
	entity3 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType inherits: entity2 parentType.
	self javaClass: entity1 parentType implements: entity3 parentType.

	self assert: (MiDeadCodeJavaImplementsInterfaceHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaOverridesHeuristicDeadNoInterface [
	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadCodeJavaOverridesInvokedHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaOverridesHeuristicDeadNoInvocation [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self assert: (MiDeadCodeJavaOverridesInvokedHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaOverridesHeuristicDeadNoMethod [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doOtherThing()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self assert: (MiDeadCodeJavaOverridesInvokedHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestJavaOverridesHeuristicNotDead [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self javaInvokeMethod: entity2.

	self deny: (MiDeadCodeJavaOverridesInvokedHeuristic new isDead: entity1)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameJustTest [

	| entity |
	entity := self pharoMethod: 'test'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameNotTest [

	| entity |
	entity := self pharoMethod: 'whateverFunctionality'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameTestosterone [

	| entity |
	entity := self pharoMethod: 'testosterone'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicNotDead [
	| entity |
	entity := self pharoMethod: 'testWhateverFunctionality'  inClass: 'IsAClassTest'.

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : 'tests - heuristics' }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicWrongClassName [

	| entity |
	entity := self pharoMethod: 'testWhateverFunctionality'  inClass: 'NotATestClass'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]
