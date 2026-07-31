Class {
	#name : 'MiDeadCodeBrowserModelTest',
	#superclass : 'MiDeadCodeRuleModelAbstractTest',
	#instVars : [
		'browser'
	],
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> modelDeleteLines: aBoolean [

	model instVarNamed: #deleteLines put: aBoolean 
]

{ #category : 'running' }
MiDeadCodeBrowserModelTest >> setUp [
	super setUp.

	model := MiDeadCodeBrowserModel new.
	model browser: Mock new.

]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testClearResultListWhenReceivingEntities [

	model deadEntities addAll: { FamixStMethod new . FamixStMethod new }.
	model followEntity: { FamixStMethod new }.
	
	self assert: model deadEntities size equals: 0
]

{ #category : 'tests' }
MiDeadCodeBrowserModelTest >> testGatherRulesList [
	"Expected number must be updated according to number of non abstract rule classes"

	self assert: model availableRules size equals: 13
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
