Class {
	#name : #MiDeadCodeBrowserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDeadCodeBrowserModelTest >> class: aClass inheritFrom: superclassName [

	FamixStInheritance new
		superclass: (FamixStClass new name: superclassName) ;
		subclass: aClass
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> invokeJavaMethod: entity [

	FamixJavaInvocation new
		sender: entity ;
		candidates: { entity }.
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> invokedMethod: methName [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.

	FamixStInvocation new
		sender: entity ;
		candidates: { entity }.

	^entity
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> javaClass: aClass implements: anInterface [

	FamixJavaImplementation new
		implementingClass: aClass ;
		interface: anInterface
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> javaClassMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaClass new).

	^entity
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> javaInterfaceMethod: methSignature [

	| entity |
	entity := FamixJavaMethod new.
	entity signature: methSignature.
	entity parentType: (FamixJavaInterface new).

	^entity
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> method: methName annotatedWith: annotationName [

	| entity |
	entity := FamixJavaMethod new.
	entity name: methName.

	FamixJavaAnnotationInstance new
		annotationType: (FamixJavaAnnotationType new name: annotationName) ;
		annotatedEntity: entity.

	^entity
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> method: methName inClass: className [

	| entity |
	entity := FamixStMethod new.
	entity name: methName.
	entity parentType: (FamixStClass new name: className).

	^entity
]

{ #category : #running }
MiDeadCodeBrowserModelTest >> modelWithHeuristic: aCollection [

	model initializeHeuristics.
	model selectedHeuristics addAll: aCollection.
	model sortHeuristics.

]

{ #category : #running }
MiDeadCodeBrowserModelTest >> setUp [
	super setUp.

	model := MiDeadCodeBrowserModel new.
	model browser: Mock new.

]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testFirstRoundDeadNotRefuted [

	self modelWithHeuristic: { MiDeadCodeNamingConventionHeuristic new }.

	model followEntity: { self method: 'whateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testFirstRoundNoDead [

	model followEntity: { self invokedMethod: 'someFunctionality' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 0
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testFirstRoundOneDead [

	model followEntity: { FamixStMethod new }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 1
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testFirstRoundRefutedDead [
	"entity is not invoked, but it should be considered a test method"

	self modelWithHeuristic: { MiDeadCodeNamingConventionHeuristic new }.

	model followEntity: { self method: 'testWhateverFunctionality' inClass: 'IsAClassTest' }.

	self assert: model deadEntities size equals: 0.
	model firstRoundComputation.
	self assert: model deadEntities size equals: 0
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
	entity := self invokedMethod: 'someFunctionality'.

	self deny: (MiDeadCodeNoIncomingInvocationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicIsDead [
	| entity |
	entity := self method: 'someFunctionality' inClass: 'SomeClass'.
	self class: entity parentType inheritFrom: 'Object'.

	self assert: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testPharoTestCaseHeuristicNotDead [
	| entity |
	entity := self method: 'someFunctionality' inClass: 'SomeClass'.
	self class: entity parentType inheritFrom: 'TestCase'.

	self deny: (MiDeadCodePharoTestCaseSubClassHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testSortHeuristics [
	"entity is not invoked, but it should be considered a test method"

	self modelWithHeuristic: {
		MiDeadCodeNamingConventionHeuristic new .
		MiDeadCodeJavaImplementedInterfaceHeuristic new }.

	self assert: model selectedHeuristics size equals: 3.
	self assert: model selectedHeuristics first  class equals: MiDeadCodeJavaImplementedInterfaceHeuristic.
	self assert: model selectedHeuristics second class equals: MiDeadCodeNamingConventionHeuristic.
	self assert: model selectedHeuristics third  class equals: MiDeadCodeNoIncomingInvocationHeuristic.
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
	entity := self method: 'someFunctionality' annotatedWith: 'Deprecated'.

	self assert: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaAnnotationHeuristicNotDead [

	| entity |
	entity := self method: 'someFunctionality' annotatedWith: 'BeforeClass'.

	self deny: (MiDeadCodeJavaTestAnnotationHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoInterface [
	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self invokeJavaMethod: entity2.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoInvocation [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicDeadNoMethod [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doOtherThing()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self invokeJavaMethod: entity2.

	self assert: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestJavaInterfaceHeuristicNotDead [

	| entity1 entity2 |
	entity1 := self javaClassMethod: 'doSomething()'.
	entity2 := self javaInterfaceMethod: 'doSomething()'.
	self javaClass: entity1 parentType implements: entity2 parentType.
	self invokeJavaMethod: entity2.

	self deny: (MiDeadCodeJavaImplementedInterfaceHeuristic new isDead: entity1)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameJustTest [

	| entity |
	entity := self method: 'test'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameNotTest [

	| entity |
	entity := self method: 'whateverFunctionality'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicMethodNameTestosterone [

	| entity |
	entity := self method: 'testosterone'  inClass: 'IsAClassTest'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicNotDead [
	| entity |
	entity := self method: 'testWhateverFunctionality'  inClass: 'IsAClassTest'.

	self deny: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]

{ #category : #tests }
MiDeadCodeBrowserModelTest >> testTestNamingConventionHeuristicWrongClassName [

	| entity |
	entity := self method: 'testWhateverFunctionality'  inClass: 'NotATestClass'.

	self assert: (MiDeadCodeNamingConventionHeuristic new isDead: entity)
]
