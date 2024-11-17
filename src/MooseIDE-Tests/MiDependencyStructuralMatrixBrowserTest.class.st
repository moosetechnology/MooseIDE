Class {
	#name : #MiDependencyStructuralMatrixBrowserTest,
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
MiDependencyStructuralMatrixBrowserTest >> browserClass [
	^ MiDependencyStructuralMatrixBrowser
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> defaultEntityToSelect [

	^{ 	FamixStClass new name: 'a'. FamixStClass new name: 'b' }
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> makeGraphNode: anEntity [

	^AIGraphNode new
		model: anEntity ;
		yourself
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> setUp [
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
MiDependencyStructuralMatrixBrowserTest >> shapeAtRow: rEntity column: cEntity2 [

	^browser diagram canvas shapes detect: [ :sh |
		(sh model key model = rEntity) and: 
		[ sh model value model = cEntity2 ]
	]
]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testCanTagEntities [

	self deny: browser canTagEntities
]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testDoesNotOpenEmptyDetailedDSM [
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
MiDependencyStructuralMatrixBrowserTest >> testDoubleClickCallsUserAction [
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
MiDependencyStructuralMatrixBrowserTest >> testOutgoingDependencyFromInvocation [

	| dependencies |
	dependencies := class1 methods anyOne queryAllOutgoingForDSM.

	self assert: dependencies size equals: 1.
	self assert: dependencies anyOne class equals: FamixJavaInvocation.
	self assert: dependencies anyOne candidates anyOne name equals: 'mth2'.

]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testOutgoingDependencyFromMethodDeclaredType [

	| mth2 dependencies |
	mth2 := class2 methods anyOne.
	mth2 declaredType: class3.

	dependencies := mth2 queryAllOutgoingForDSM.

	self assert: dependencies size equals: 1.
	self assert: dependencies anyOne class equals: FamixJavaClass.
	self assert: dependencies anyOne name equals: 'Class3'.

]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testOutgoingDependencyFromVariableDeclaredType [

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
MiDependencyStructuralMatrixBrowserTest >> testOutgoingDependencyFromVariableDeclaredTypeParametric [
	"code: 
	Class2
		mth2
			ParametricClass<Class3> local2
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
MiDependencyStructuralMatrixBrowserTest >> testTitleOfDSM [

	browser followEntity: {  class1 . class2 }.

	browser withWindowDo: [ : window |
		self assert: (window title beginsWith: 'Dependency Structural Matrix ').
		self assert: (window title includesSubstring: 'Class1').
		self assert: (window title includesSubstring: 'Class2')
	]
]

{ #category : #tests }
MiDependencyStructuralMatrixBrowserTest >> testTitleOfDetailedDSM [
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
