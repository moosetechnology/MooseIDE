Class {
	#name : 'MiCoUsageModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'previousApplication',
		'application',
		'specModel'
	],
	#category : 'MooseIDE-CoUsageMap-Tests-Model',
	#package : 'MooseIDE-CoUsageMap-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
MiCoUsageModelTest >> setUp [

	super setUp.

	specModel := MiCoUsageMapModel new.

	previousApplication := MiApplication current.
	application := MiTestApplication new.
	MiApplication current: application.

	MiCoUsageMapBrowser newApplication: application model: specModel.
	specModel followEntity: MiCoUsageTestFamixModel new allMethods
]

{ #category : 'initialization' }
MiCoUsageModelTest >> tearDown [

	MiApplication reset.
	MiApplication current: previousApplication.

	super tearDown
]

{ #category : 'tests' }
MiCoUsageModelTest >> test01Basic [

	self assert: specModel containerBoxes size equals: 5.
	self assert: specModel innerBoxes size equals: 5. "var2 is not used"
]

{ #category : 'tests' }
MiCoUsageModelTest >> test02MethodsAttributes [

	| method |

	method := specModel containerBoxNamed: #method1.
	self assert: method class equals: MiCoContainerBox.
	self assert: method innerBoxes size equals: 1.
	self assert: method innerBoxes anyOne class equals: MiCoInnerBox.

	self assert: (specModel containerBoxNamed: #method2) innerBoxes size equals: 1.
	self assert: (specModel containerBoxNamed: #method3) innerBoxes size equals: 3.

	self assert: (specModel getInnerBoxNamed: #att1) numberOfUses equals: 1.
	self assert: (specModel getInnerBoxNamed: #att6) numberOfUses equals: 3.

	self should: [specModel getInnerBoxNamed: #var2] raise: Error.
]

{ #category : 'tests' }
MiCoUsageModelTest >> test03AttributeWidth [

	| method |
	method := specModel containerBoxNamed: #method1.
	self assert: ((specModel getInnerBoxNamed: #att1) numberOfUsesOn: method) equals: 3.

	method := specModel containerBoxNamed: #method3.
	self assert: ((specModel getInnerBoxNamed: #att4) numberOfUsesOn: method) equals: 1
]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorOneTaggedInnerBox [

	| tag |

	tag := specModel currentMooseModel tagNamed: 'aTag'.
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att6).

	specModel automaticColor.

	self
		assertCollection: (specModel containerBoxNamed: #method4) mooseEntity allTags
		hasSameElements: {tag}.
	self
		assertCollection: (specModel containerBoxNamed: #method5) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAllTagged [

	| tag |

	tag := specModel currentMooseModel tagNamed: 'aTag'.
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att3).
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att4).
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att5).

	specModel automaticColor.

	self
		assertCollection: (specModel containerBoxNamed: #method3) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAndAboveThreshold [

	| tag |

	tag := specModel currentMooseModel tagNamed: 'aTag'.
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att3).
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att4).

	specModel settings threshold75PercentGroup: 65. 
	specModel automaticColor.

	self
		assertCollection: (specModel containerBoxNamed: #method3) mooseEntity allTags
		hasSameElements: {tag}.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testAutomaticColorSeveralInnerBoxAndBelowThreshold [

	| tag |

	tag := specModel currentMooseModel tagNamed: 'aTag'.
	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att3).

	specModel settings threshold75PercentGroup: 65.
	specModel automaticColor.

	self assert: (specModel containerBoxNamed: #method3) mooseEntity allTags isEmpty

]

{ #category : 'tests' }
MiCoUsageModelTest >> testLastTagInitialization [

	self assert: specModel selectedTag isNil.

]

{ #category : 'tests' }
MiCoUsageModelTest >> testLastTagWithTag [

	| tag |
	tag := specModel currentMooseModel tagNamed: 'aTag'.

	specModel setTag: tag onInnerBox: (specModel getInnerBoxNamed: #att3).

	self assert: specModel selectedTag equals: tag.

]
