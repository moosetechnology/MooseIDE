"
I test tag usage in DistributionMap
"
Class {
	#name : 'MiDistributionMapTagTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'simpleTag',
		'compositeTag',
		'newTag',
		'class1',
		'class2'
	],
	#category : 'MooseIDE-DistributionMap-Tests',
	#package : 'MooseIDE-DistributionMap-Tests'
}

{ #category : 'running' }
MiDistributionMapTagTest >> setUp [

	super setUp.
	model := FamixTagTestModel new.
	class1 := FamixTagTestClass named: 'aClass1' model: model.
	class2 := FamixTagTestClass named: 'aClass2' model: model.
	simpleTag := model createTagNamed: 'leaf'.
	compositeTag := (model createTagNamed: 'parent')
		                addSubTag: simpleTag;
		                yourself.
	newTag := model createTagNamed: 'newTag'
]

{ #category : 'tests' }
MiDistributionMapTagTest >> testIsApplicableTo [

	simpleTag tagEntity: class1.
	self assert: (simpleTag isApplicableTo: class1)
]

{ #category : 'tests' }
MiDistributionMapTagTest >> testIsApplicableToOtherClass [

	simpleTag tagEntity: class1.
	self deny: (simpleTag isApplicableTo: class2)
]

{ #category : 'tests' }
MiDistributionMapTagTest >> testIsApplicableToOtherModel [
	
	| class3 |
	class3 := FamixTagTestClass named: 'aClass3'.
	simpleTag tagEntity: class3.
	self assert: (simpleTag isApplicableTo: class3)
]

{ #category : 'tests' }
MiDistributionMapTagTest >> testIsNotApplicableTo [

	self deny: (simpleTag isApplicableTo: class1)
]
