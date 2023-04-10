Class {
	#name : #MiCoUsageModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-CoUsageMap-Tests-Browser'
}

{ #category : #initialization }
MiCoUsageModelTest >> setUp [

	super setUp.

	model := MiCoUsageMapModel new.

	MiCoUsageMapBrowser
		newApplication: MiTestApplication new
		model: model.
	model followEntity: MiCoUsageTestFamixModel new allMethods.

]

{ #category : #tests }
MiCoUsageModelTest >> test01Basic [

	self assert: model containerBoxes size equals: 5.
	self assert: model innerBoxes size equals: 5. "var5 is not used"
]

{ #category : #tests }
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

{ #category : #tests }
MiCoUsageModelTest >> test03AttributeWidth [

	| method attribute shapes |
	attribute := model getInnerBoxNamed: #var1.
	method := model containerBoxNamed: #method1.
	self assert: (attribute numberOfUsesOn: method) equals: 3.

	attribute := model getInnerBoxNamed: #var4.
	method := model containerBoxNamed: #method3.
	self assert: (attribute numberOfUsesOn: method) equals: 1
]
