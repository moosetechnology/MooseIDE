Class {
	#name : #MiDeadCodeBrowserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDeadCodeBrowserModelTest >> assertHeuristic: heuristicClass on: anEntity [

	self assert: (heuristicClass new isDead: anEntity)
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> denyHeuristic: heuristicClass on: anEntity [

	self deny: (heuristicClass new isDead: anEntity)
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> setUp [
	super setUp.

	model := MiDeadCodeBrowserModel new.
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testGatherHeuristicsList [
	"Expected number must be updated according to number of non abstract heuristics classes"

	self assert: model gatherHeuristics size equals: 5
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testNoInvocationHeuristicIsDead [

	| entity |
	entity := FamixStMethod new.
	self assert: (MiDeadCodeNoIncomingInvocationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testNoInvocationHeuristicNotDead [

	| entity |
	entity := FamixStMethod new.
	FamixStInvocation new
		sender: entity ;
		candidates: { entity }.

	self deny: (MiDeadCodeNoIncomingInvocationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicIsDead [
	| entity |
	entity := FamixStMethod new.
	entity parentType: (FamixStClass new name: 'SomeClass').
	FamixStInheritance new
		superclass: (FamixStClass new name: 'Object') ;
		subclass: entity parentType.

	self assert: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicNotDead [
	| entity |
	entity := FamixStMethod new.
	entity parentType: (FamixStClass new name: 'SomeClass').
	FamixStInheritance new
		superclass: (FamixStClass new name: 'TestCase') ;
		subclass: entity parentType.

	self deny: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicDeadNoAnnotation [

	| entity |
	entity := FamixJavaMethod new.

	self assert: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicDeadWrongAnnotation [

	| entity |
	entity := FamixJavaMethod new.
	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: 'Deprecated') ;
		annotatedEntity: entity.

	self assert: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicNotDead [

	| entity |
	entity := FamixJavaMethod new.
	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: 'BeforeClass') ;
		annotatedEntity: entity.

	self deny: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoInterface [
	| entity1 entity2 |
	entity1 := FamixJavaMethod new.
	entity1 signature: 'doSomething()'.
	entity1 parentType: (FamixJavaClass new).

	entity2 := FamixJavaMethod new.
	entity2 signature: 'doSomething()'.
	entity2 parentType: (FamixJavaInterface new).

	FamixJavaInvocation new
		sender: entity2 ;
		candidates: { entity2 }.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoInvocation [

	| entity1 entity2 |
	entity1 := FamixJavaMethod new.
	entity1 signature: 'doSomething()'.
	entity1 parentType: (FamixJavaClass new).

	entity2 := FamixJavaMethod new.
	entity2 signature: 'doSomething()'.
	entity2 parentType: (FamixJavaInterface new).

	FamixJavaImplementation new
		implementingClass: entity1 parentType ;
		interface: entity2 parentType.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoMethod [

	| entity1 entity2 |
	entity1 := FamixJavaMethod new.
	entity1 signature: 'doSomething()'.
	entity1 parentType: (FamixJavaClass new).

	entity2 := FamixJavaMethod new.
	entity2 signature: 'doOtherThing()'.
	entity2 parentType: (FamixJavaInterface new).

	FamixJavaImplementation new
		implementingClass: entity1 parentType ;
		interface: entity2 parentType.
	
	FamixJavaInvocation new
		sender: entity2 ;
		candidates: { entity2 }.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicNotDead [

	| entity1 entity2 |
	entity1 := FamixJavaMethod new.
	entity1 signature: 'doSomething()'.
	entity1 parentType: (FamixJavaClass new).

	entity2 := FamixJavaMethod new.
	entity2 signature: 'doSomething()'.
	entity2 parentType: (FamixJavaInterface new).

	FamixJavaImplementation new
		implementingClass: entity1 parentType ;
		interface: entity2 parentType.
	
	FamixJavaInvocation new
		sender: entity2 ;
		candidates: { entity2 }.

	self deny: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicIsDead [
	| entity |
	entity := FamixStMethod new.
	entity name: 'testWhateverFunctionality'.
	entity parentType: (FamixStClass new name: 'IsAClassTest').

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameJustTest [

	| entity |
	entity := FamixStMethod new.
	entity name: 'test'.
	entity parentType: (FamixStClass new name: 'IsAClassTest').

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameNotTest [

	| entity |
	entity := FamixStMethod new.
	entity name: 'whateverFunctionality'.
	entity parentType: (FamixStClass new name: 'IsAClassTest').

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameTestosterone [

	| entity |
	entity := FamixStMethod new.
	entity name: 'testosterone'.
	entity parentType: (FamixStClass new name: 'IsAClassTest').

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicWrongClassName [

	| entity |
	entity := FamixStMethod new.
	entity name: 'testWhateverFunctionality'.
	entity parentType: (FamixStClass new name: 'NotATestClass').

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]
