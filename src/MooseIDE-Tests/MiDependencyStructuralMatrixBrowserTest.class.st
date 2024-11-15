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

	^ { class1 . class2 }
]

{ #category : #running }
MiDependencyStructuralMatrixBrowserTest >> setUp [
	| mth1 mth2 |

	super setUp.
	
	model := FamixStModel new.
	class1 := model newClassNamed: 'class1'.
	class2 := model newClassNamed: 'class2'.
	class3 := model newClassNamed: 'class3'.

	mth1 := (model newMethodNamed: 'mth1') parentType: class1.
	mth2 := (model newMethodNamed: 'mth2') parentType: class2.
	model newInvocation
		sender: mth1 ;
		candidates: { mth2 }.
]

{ #category : #'tests - tags' }
MiDependencyStructuralMatrixBrowserTest >> shapeAtRow: rEntity column: cEntity2 [

	^browser diagram canvas shapes detect: [ :sh |
		(sh model key model = rEntity) and: 
		[ sh model value model = cEntity2 ]
	]
]

{ #category : #'tests - tags' }
MiDependencyStructuralMatrixBrowserTest >> testCanTagEntities [

	self deny: browser canTagEntities
]

{ #category : #'tests - tags' }
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

{ #category : #'tests - tags' }
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
