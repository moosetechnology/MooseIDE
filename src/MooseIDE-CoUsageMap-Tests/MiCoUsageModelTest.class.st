Class {
	#name : 'MiCoUsageModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseIDE-CoUsageMap-Tests-Browser',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiCoUsageModelTest >> setUp [

	super setUp.

	model := MiCoUsageMapModel new.

	MiCoUsageMapBrowser
		newApplication: MiTestApplication new
		model: model.
	model followEntity: MiCoUsageTestFamixModel new allMethods.

]

{ #category : 'initialization' }
MiCoUsageModelTest >> tearDown [ 

	MiCoUsageMapSettings reset.

	super tearDown
]

{ #category : 'tests' }
MiCoUsageModelTest >> test01Basic [

	self assert: model containerBoxes size equals: 5.
	self assert: model innerBoxes size equals: 5. "var5 is not used"
]

{ #category : 'tests' }
MiCoUsageModelTest >> test02MethodsAttributes [

	| method |

	method := model containerBoxNamed: #method1.
	self assert: method class equals: MiCoContainerBox.
	self assert: method innerBoxes size equals: 2.
	self assert: method innerBoxes first class equals: MiCoInnerBox.

	self assert: (model containerBoxNamed: #method2) innerBoxes size equals: 0.
	self assert: (model containerBoxNamed: #method3) innerBoxes size equals: 3.
	self assert: (model getInnerBoxNamed: #var2) numberOfUses equals: 2.
	self assert: (model getInnerBoxNamed: #var4) numberOfUses equals: 1.
	self should: [model getInnerBoxNamed: #var5] raise: Error.
]

{ #category : 'tests' }
MiCoUsageModelTest >> test03AttributeWidth [

	| method |
	method := model containerBoxNamed: #method1.
	self assert: ((model getInnerBoxNamed: #var1) numberOfUsesOn: method) equals: 3.

	method := model containerBoxNamed: #method3.
	self assert: ((model getInnerBoxNamed: #var4) numberOfUsesOn: method) equals: 1
]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorOneTaggedInnerBox [

	| tag |

	tag := model currentMooseModel tagNamed: 'aTag'.
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var6).

	model automaticColor.

	self
		assertCollection: (model containerBoxNamed: #method4) mooseEntity allTags
		hasSameElements: {tag}.
	self
		assertCollection: (model containerBoxNamed: #method5) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAllTagged [

	| tag |

	tag := model currentMooseModel tagNamed: 'aTag'.
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var2).
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var3).
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var4).

	model automaticColor.

	self
		assertCollection: (model containerBoxNamed: #method3) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAndAboveThreshold [

	| tag |

	tag := model currentMooseModel tagNamed: 'aTag'.
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var2).
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var3).

	model settings threshold75PercentGroup: 65. 
	model automaticColor.

	self
		assertCollection: (model containerBoxNamed: #method3) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAndBelowThreshold [

	| tag |

	tag := model currentMooseModel tagNamed: 'aTag'.
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var2).
	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var3).

	model automaticColor.

	self assert: (model containerBoxNamed: #method3) mooseEntity allTags isEmpty

]

{ #category : 'tests' }
MiCoUsageModelTest >> testLastTagInitialization [

	self assert: model selectedTag isNil.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testLastTagWithTag [

	| tag |
	tag := model currentMooseModel tagNamed: 'aTag'.

	model setTag: tag onInnerBox: (model getInnerBoxNamed: #var2).

	self assert: model selectedTag equals: tag.

]
