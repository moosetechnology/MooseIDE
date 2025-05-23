Class {
	#name : #MiDSMBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'model',
		'class1',
		'class2',
		'class3'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDSMBrowserTest >> browserClass [
	^ MiDSMBrowser
]

{ #category : #running }
MiDSMBrowserTest >> defaultEntityToSelect [

	^{ 	FamixStClass new name: 'a'. FamixStClass new name: 'b' }
]

{ #category : #running }
MiDSMBrowserTest >> makeGraphNode: anEntity [

	^AIGraphNode new
		model: anEntity ;
		yourself
]

{ #category : #running }
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

{ #category : #running }
MiDSMBrowserTest >> shapeAtRow: rEntity column: cEntity2 [

	^browser diagram canvas shapes detect: [ :sh |
		(sh model key model = rEntity) and: 
		[ sh model value model = cEntity2 ]
	]
]

{ #category : #tests }
MiDSMBrowserTest >> testCanTagEntities [

	self deny: browser canTagEntities
]

{ #category : #tests }
MiDSMBrowserTest >> testCellListTupleDependencies [
	"detailed DSM title should show the original entities"

	| tuple |
	browser followEntity: {  class1 . class2 }.

	tuple := (self shapeAtRow: class1 column: class2) model.

	self assert: (browser diagram listTupleDependencies: tuple) size equals: 1.
	self assert: (browser diagram listTupleDependencies: tuple) anyOne class equals: FamixJavaInvocation 
]

{ #category : #tests }
MiDSMBrowserTest >> testDoesNotOpenEmptyDetailedDSM [
	"sets a fake spec model that delegates #userActionOn: to the original model
	 We checks that #userActionOn: was called and #openDetailedDSMOn: was not"
	| originalModel mockModel userAction detailedDSM  |

	browser followEntity: {  class2 . class3 }.

	originalModel := browser model.
	mockModel := Mock named: 'DSM-spec-model'.
	(mockModel stub userActionOn: Any) will: [ :arg |
		userAction := arg.
		originalModel userActionOn: arg ].
	(mockModel stub openDetailedDSMOn: Any) will: [ :arg | detailedDSM := arg ].
	detailedDSM := nil.
	browser diagram specModel: mockModel.

	(self shapeAtRow: class2 column: class3)
		announce: RSMouseDoubleClick.

	self assert: userAction isNotNil.
	self assert: userAction key model equals: class2.
	self assert: userAction value model equals: class3.

	self assert: detailedDSM isNil
]

{ #category : #tests }
MiDSMBrowserTest >> testDontShowSelfDependenciesHideDiagonalWeight [

	| tuple |
	browser model settings setItem: #selfDependenciesSetting value: false.
	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityA).
	browser model dependencies
		recordDependencies: #(1 2 3) from: #entityA to: #entityA.

	self assert: (browser model getTupleDependencyWeight: tuple) equals: 0.
]

{ #category : #tests }
MiDSMBrowserTest >> testDontShowSelfDependenciesShowNonDiagonalWeight [

	| tuple |
	browser model settings setItem: #selfDependenciesSetting value: false.
	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityB).
	browser model dependencies
		recordDependencies: #(1 2 3) from: #entityA to: #entityB.

	self assert: (browser model getTupleDependencyWeight: tuple) equals: 3.
]

{ #category : #tests }
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

{ #category : #tests }
MiDSMBrowserTest >> testOutgoingDependencyFromInvocation [

	| dependencies |
	dependencies := class1 methods anyOne queryAllOutgoingForDSM.

	self assert: dependencies size equals: 1.
	self assert: dependencies anyOne class equals: FamixJavaInvocation.
	self assert: dependencies anyOne candidates anyOne name equals: 'mth2'.

]

{ #category : #tests }
MiDSMBrowserTest >> testOutgoingDependencyFromMethodDeclaredType [

	| mth2 dependencies |
	mth2 := class2 methods anyOne.
	mth2 declaredType: class3.

	dependencies := mth2 queryAllOutgoingForDSM.

	self assert: dependencies size equals: 1.
	self assert: dependencies anyOne class equals: FamixJavaClass.
	self assert: dependencies anyOne name equals: 'Class3'.

]

{ #category : #tests }
MiDSMBrowserTest >> testOutgoingDependencyFromVMethodDeclaredTypeParametric [
	"code: 
	Class2
		ParametricClass<Class1> mth2
	Note: FamixJavaConcretization is an association and we are not interested in its genericEntity here
	Note: hueristic to detect a concreteParameter being a genuine class is to check it has children
	  That's why we use Class1 and not Class3 as concreteParameter"

	| mth2 parametricClass dependencies |
	parametricClass := model newParametricClass
		name: 'ParametricClass' ;
		genericization: model newConcretization ;
		addConcreteParameter: class1 ;
		yourself.

	mth2 := class2 methods anyOne.
	mth2 declaredType: parametricClass.

	dependencies := mth2 queryAllOutgoingForDSM.

	self assert: dependencies size equals: 2.
	dependencies do: [ :dep |
		{ 'ParametricClass' . 'Class1' } includes: dep name
	]
]

{ #category : #tests }
MiDSMBrowserTest >> testOutgoingDependencyFromVariableDeclaredType [

	| mth2 dependencies |
	mth2 := class2 methods anyOne.
	(model newLocalVariableNamed: 'local2')
		parentBehaviouralEntity: mth2 ;
		declaredType: class3.

	dependencies := mth2 queryAllOutgoingForDSM.

	self assert: dependencies size equals: 1.
	self assert: dependencies anyOne class equals: FamixJavaClass.
	self assert: dependencies anyOne name equals: 'Class3'.

]

{ #category : #tests }
MiDSMBrowserTest >> testOutgoingDependencyFromVariableDeclaredTypeParametric [
	"code: 
	Class2
		mth2
			ParametricClass<Class1> local2
	Note: FamixJavaConcretization is an association and we are not interested in its genericEntity here
	Note: heuristic to detect a concreteParameter being a genuine class is to check it has children
	  That's why we use Class1 and not Class3 as concreteParameter"

	| mth2 parametricClass dependencies |
	parametricClass := model newParametricClass
		name: 'ParametricClass' ;
		genericization: model newConcretization ;
		addConcreteParameter: class1 ;
		yourself.

	mth2 := class2 methods anyOne.
	(model newLocalVariableNamed: 'local2')
		parentBehaviouralEntity: mth2 ;
		declaredType: parametricClass.

	dependencies := mth2 queryAllOutgoingForDSM.

	self assert: dependencies size equals: 2.
	dependencies do: [ :dep |
		{ 'ParametricClass' . 'Class1' } includes: dep name
	]
]

{ #category : #tests }
MiDSMBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiDSMBrowserTest >> testSettingsChanged [

	| stubDSM redrawn |
	redrawn := false.
	stubDSM := Mock new.
	stubDSM stub run will: [ redrawn := true ].
	browser mainPresenter: stubDSM.

	browser model settingsChanged: true.
		
	self assert: redrawn
]

{ #category : #tests }
MiDSMBrowserTest >> testSettingsNotChanged [

	| stubDSM redrawn |
	redrawn := false.
	stubDSM := Mock new.
	stubDSM stub run will: [ redrawn := true ].
	browser mainPresenter: stubDSM.

	browser model settingsChanged: false.
		
	self deny: redrawn
]

{ #category : #tests }
MiDSMBrowserTest >> testShowSelfDependenciesDoNotHideDiagonalWeight [

	| tuple |
	browser model settings setItem: #selfDependenciesSetting value: true.
	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityA).
	browser model dependencies
		recordDependencies: #(1 2 3) from: #entityA to: #entityA.

	self assert: (browser model getTupleDependencyWeight: tuple) equals: 3.
]

{ #category : #tests }
MiDSMBrowserTest >> testTitleOfDSM [

	browser followEntity: {  class1 . class2 }.

	browser withWindowDo: [ : window |
		self assert: (window title beginsWith: 'Dependency Structural Matrix ').
		self assert: (window title includesSubstring: 'Class1').
		self assert: (window title includesSubstring: 'Class2')
	]
]

{ #category : #tests }
MiDSMBrowserTest >> testTitleOfDetailedDSM [
	"detailed DSM title should show the original entities"
	| detailedDSM |

	browser followEntity: {  class1 . class2 }.

	detailedDSM := browser model
		openDetailedDSMOn: ( (self makeGraphNode: class1) -> (self makeGraphNode: class2) ).

	detailedDSM withWindowDo: [ : window || title |
		title := window title.
		window close.
		self assert: title equals: 'DSM Class1 -> Class2'
	]
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsCycle [

	| tarjanGraph tuple |

	tarjanGraph := browser model graph graph.
	tarjanGraph nodes: { #entityA . #entityB }.
	tarjanGraph addEdge: #entityA -> #entityB from: #key to: #value.
	tarjanGraph addEdge: #entityB -> #entityA from: #key to: #value.
	tarjanGraph run.

	tuple := (tarjanGraph findNode: #entityA) -> (tarjanGraph findNode: #entityB).
 
	self assert: (browser model isCycle: tuple)
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsDependency [

	| tuple |

	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityB).
	browser model dependencies
		recordDependencies: #(1 2 3) from: #entityA to: #entityB.

	self assert: (browser model isDependency: tuple)
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsDiagonal [

	| node tuple |

	node := AITarjanNode with: #entityA.
	tuple := node -> node.

	self assert: (browser model isDiagonal: tuple)
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsNotCycle [

	| tarjanGraph tuple |

	tarjanGraph := browser model graph graph.
	tarjanGraph nodes: { #entityA . #entityB }.
	tarjanGraph addEdge: #entityA -> #entityB from: #key to: #value.
	tarjanGraph run.

	tuple := (tarjanGraph findNode: #entityA) -> (tarjanGraph findNode: #entityB).
 
	self deny: (browser model isCycle: tuple)
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsNotDependency [

	| tuple |

	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityB).

	self deny: (browser model isDependency: tuple)
]

{ #category : #tests }
MiDSMBrowserTest >> testTupleIsNotDiagonal [

	| tuple |

	tuple := (AITarjanNode with: #entityA) -> (AITarjanNode with: #entityB).

	self deny: (browser model isDiagonal: tuple)
]
