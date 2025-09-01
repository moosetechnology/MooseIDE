Class {
	#name : 'MiDSMBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#instVars : [
		'model',
		'class1',
		'class2',
		'class3'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDSMBrowserTest >> browserClass [

	^ MiDSMBrowser
]

{ #category : 'running' }
MiDSMBrowserTest >> defaultEntityToSelect [

	^{ 	FamixStClass new name: 'a'. FamixStClass new name: 'b' }
]

{ #category : 'running' }
MiDSMBrowserTest >> makeGraphNode: anEntity [

	^AIGraphNode new
		model: anEntity ;
		yourself
]

{ #category : 'running' }
MiDSMBrowserTest >> setUp [
	| mth1 mth2 |

	super setUp.

	"Note: need to be a Java model to test ParametricEntities"
	model := FamixJavaModel new.
	class1 := model newClassNamed: 'Class1'.
	class2 := model newClassNamed: 'Class2'.
	class3 := model newClassNamed: 'Class3'.

	mth1 := (model newMethodNamed: 'mth1') parentType: class1.
	mth2 := (model newMethodNamed: 'mth2') parentType: class2.
	model newInvocation
		sender: mth1 ;
		candidates: { mth2 }.

]

{ #category : 'running' }
MiDSMBrowserTest >> shapeAtRow: rEntity column: cEntity2 [

	^browser diagram canvas shapes detect: [ :sh |
		(sh model key model = rEntity) and: 
		[ sh model value model = cEntity2 ]
	]
]

{ #category : 'tests' }
MiDSMBrowserTest >> testCanTagEntities [

	self deny: browser canTagEntities
]

{ #category : 'tests' }
MiDSMBrowserTest >> testCellListTupleDependencies [
	"detailed DSM title should show the original entities"

	| tuple |
	browser followEntity: {  class1 . class2 }.

	tuple := (self shapeAtRow: class1 column: class2) model.

	self assert: (browser diagram listTupleDependencies: tuple) size equals: 1.
	self assert: (browser diagram listTupleDependencies: tuple) anyOne class equals: FamixJavaInvocation 
]

{ #category : 'tests' }
MiDSMBrowserTest >> testDoesNotOpenEmptyDetailedDSM [
	"sets a fake spec model that delegates #userActionOn: to the original model
	 We checks that #userActionOn: was called and #openDetailedDSMOn: was not"

	| originalModel mockModel userAction detailedDSM |
	browser followEntity: {
			class2.
			class3 }.

	originalModel := browser specModel.
	mockModel := Mock named: 'DSM-spec-model'.
	(mockModel stub userActionOn: Any) will: [ :arg |
			userAction := arg.
			originalModel userActionOn: arg ].
	(mockModel stub openDetailedDSMOn: Any) will: [ :arg |
		detailedDSM := arg ].
	detailedDSM := nil.
	browser diagram specModel: mockModel.

	(self shapeAtRow: class2 column: class3) announce: RSMouseDoubleClick.

	self assert: userAction isNotNil.
	self assert: userAction key model equals: class2.
	self assert: userAction value model equals: class3.

	self assert: detailedDSM isNil
]

{ #category : 'tests' }
MiDSMBrowserTest >> testDontShowSelfDependenciesHideDiagonalWeight [

	| tuple |
	browser specModel settings
		setItem: #selfDependenciesSetting
		value: false.
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityA).
	browser specModel dependencies
		recordDependencies: #( 1 2 3 )
		from: #entityA
		to: #entityA.

	self
		assert: (browser specModel getTupleDependencyWeight: tuple)
		equals: 0
]

{ #category : 'tests' }
MiDSMBrowserTest >> testDontShowSelfDependenciesShowNonDiagonalWeight [

	| tuple |
	browser specModel settings
		setItem: #selfDependenciesSetting
		value: false.
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityB).
	browser specModel dependencies
		recordDependencies: #( 1 2 3 )
		from: #entityA
		to: #entityB.

	self
		assert: (browser specModel getTupleDependencyWeight: tuple)
		equals: 3
]

{ #category : 'tests' }
MiDSMBrowserTest >> testDoubleClickCallsUserAction [
	"sets a fake spec model on the visualization to check that #userAction: is called
	 with the right tuple when double clicking on a square"
	| mockModel detailedDSM  |

	browser followEntity: {  class1 . class2 }.

	mockModel := Mock named: 'DSM-spec-model'.
	(mockModel stub userActionOn: Any) will: [ :arg | detailedDSM := arg ].
	detailedDSM := nil.
	browser diagram specModel: mockModel.

	(self shapeAtRow: class1 column: class2)
		announce: RSMouseDoubleClick.

	self assert: detailedDSM isNotNil.
	self assert: detailedDSM key model equals: class1.
	self assert: detailedDSM value model equals: class2.
]

{ #category : 'tests' }
MiDSMBrowserTest >> testOutgoingDependencyFromInvocation [

	| dependencies |
	dependencies := class1 methods anyOne queryAllOutgoingForDSM.

	self
		assertCollection: dependencies
		hasSameElements: class1 methods anyOne outgoingInvocations
]

{ #category : 'tests' }
MiDSMBrowserTest >> testOutgoingDependencyFromMethodDeclaredType [

	| mth2 dependencies |
	mth2 := class2 methods anyOne.
	mth2 typing: (model newEntityTyping declaredType: class3).

	dependencies := mth2 queryAllOutgoingForDSM.

	self assertCollection: dependencies hasSameElements: { mth2 typing }
]

{ #category : 'tests' }
MiDSMBrowserTest >> testOutgoingDependencyFromVMethodDeclaredTypeParametric [
	"
	public class Class2 { 
		public ParametricClass<Classs1> mth2 { }
	}
	"

	| mth2 parametricClass dependencies |
	parametricClass := model newParametricClass
		                   name: 'ParametricClass';
		                   yourself.

	mth2 := class2 methods anyOne.

	mth2 typing: (model newParametricEntityTyping
			 declaredType: parametricClass;
			 addConcretization: (model newConcretization
					  typeArgument: class1;
					  yourself);
			 yourself). "We do not need the type parameter"

	dependencies := mth2 queryAllOutgoingForDSM.

	self assertCollection: dependencies hasSameElements: {
			mth2 typing.
			mth2 typing concretizations anyOne }
]

{ #category : 'tests' }
MiDSMBrowserTest >> testOutgoingDependencyFromVariableDeclaredType [

	| mth2 dependencies |
	mth2 := class2 methods anyOne.

	(model newLocalVariableNamed: 'local2')
		parentBehaviouralEntity: mth2;
		typing: (model newEntityTyping
				 declaredType: class3;
				 yourself).

	dependencies := mth2 queryAllOutgoingForDSM.

	self
		assertCollection: dependencies
		hasSameElements: { mth2 localVariables anyOne typing }
]

{ #category : 'tests' }
MiDSMBrowserTest >> testOutgoingDependencyFromVariableDeclaredTypeParametric [
	"
	public class Class2 { 
		public mth2 { 
			ParametricClass<Classs1> local2
		}
	}
	"

	| mth2 parametricClass dependencies localVariable |
	parametricClass := model newParametricClass
		                   name: 'ParametricClass';
		                   yourself.

	mth2 := class2 methods anyOne.

	localVariable := (model newLocalVariableNamed: 'local2')
		                 parentBehaviouralEntity: mth2;
		                 typing: (model newParametricEntityTyping
				                  declaredType: parametricClass;
				                  addConcretization:
					                  (model newConcretization typeArgument: class1);
				                  yourself). "We do not need the type parameter"

	dependencies := mth2 queryAllOutgoingForDSM.

	self assertCollection: dependencies hasSameElements: {
			localVariable typing.
			localVariable typing concretizations anyOne }
]

{ #category : 'tests' }
MiDSMBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiDSMBrowserTest >> testSettingsChanged [

	| stubDSM redrawn |
	redrawn := false.
	stubDSM := Mock new.
	stubDSM stub run will: [ redrawn := true ].
	browser mainPresenter: stubDSM.

	browser specModel updateFromMemento: MiDSMMemento new.

	self assert: redrawn
]

{ #category : 'tests' }
MiDSMBrowserTest >> testSettingsNotChanged [

	| stubDSM redrawn |
	redrawn := false.
	stubDSM := Mock new.
	stubDSM stub run will: [ redrawn := true ].
	browser mainPresenter: stubDSM.

	browser specModel settingsChanged: false.

	self deny: redrawn
]

{ #category : 'tests' }
MiDSMBrowserTest >> testShowSelfDependenciesDoNotHideDiagonalWeight [

	| tuple |
	browser specModel settings
		setItem: #selfDependenciesSetting
		value: true.
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityA).
	browser specModel dependencies
		recordDependencies: #( 1 2 3 )
		from: #entityA
		to: #entityA.

	self
		assert: (browser specModel getTupleDependencyWeight: tuple)
		equals: 3
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTitleOfDSM [

	browser followEntity: {  class1 . class2 }.

	browser withWindowDo: [ : window |
		self assert: (window title beginsWith: 'Dependency Structural Matrix ').
		self assert: (window title includesSubstring: 'Class1').
		self assert: (window title includesSubstring: 'Class2')
	]
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTitleOfDetailedDSM [
	"detailed DSM title should show the original entities"

	| detailedDSM |
	browser followEntity: {
			class1.
			class2 }.

	detailedDSM := browser specModel openDetailedDSMOn:
		               (self makeGraphNode: class1)
		               -> (self makeGraphNode: class2).

	detailedDSM withWindowDo: [ :window |
			| title |
			title := window title.
			window close.
			self assert: title equals: 'DSM Class1 -> Class2' ]
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsCycle [

	| tarjanGraph tuple |
	tarjanGraph := browser specModel graph graph.
	tarjanGraph nodes: { #entityA. #entityB }.
	tarjanGraph addEdge: #entityA -> #entityB from: #key to: #value.
	tarjanGraph addEdge: #entityB -> #entityA from: #key to: #value.
	tarjanGraph run.

	tuple := (tarjanGraph findNode: #entityA)
	         -> (tarjanGraph findNode: #entityB).

	self assert: (browser specModel isCycle: tuple)
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsDependency [

	| tuple |
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityB).
	browser specModel dependencies
		recordDependencies: #( 1 2 3 )
		from: #entityA
		to: #entityB.

	self assert: (browser specModel isDependency: tuple)
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsDiagonal [

	| node tuple |
	node := AITarjanNode with: #entityA.
	tuple := node -> node.

	self assert: (browser specModel isDiagonal: tuple)
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsNotCycle [

	| tarjanGraph tuple |
	tarjanGraph := browser specModel graph graph.
	tarjanGraph nodes: { #entityA. #entityB }.
	tarjanGraph addEdge: #entityA -> #entityB from: #key to: #value.
	tarjanGraph run.

	tuple := (tarjanGraph findNode: #entityA)
	         -> (tarjanGraph findNode: #entityB).

	self deny: (browser specModel isCycle: tuple)
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsNotDependency [

	| tuple |
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityB).

	self deny: (browser specModel isDependency: tuple)
]

{ #category : 'tests' }
MiDSMBrowserTest >> testTupleIsNotDiagonal [

	| tuple |
	tuple := (AITarjanNode with: #entityA)
	         -> (AITarjanNode with: #entityB).

	self deny: (browser specModel isDiagonal: tuple)
]
