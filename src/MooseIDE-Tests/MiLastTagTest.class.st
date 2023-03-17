Class {
	#name : #MiLastTagTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'model1',
		'model2'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiLastTagTest >> setUp [

	super setUp.
	model1 := MooseModel new.
	model2 := MooseModel new.
]

{ #category : #tests }
MiLastTagTest >> testTagListNoTags [

	self assert: (application tagListForMooseModel: model1) isEmpty.
]

{ #category : #tests }
MiLastTagTest >> testTagListSeveralModels [
	| tag11 tag12 tag21 |
	tag11 := model1 tagNamed: 'tag11'.
	tag12 := model1 tagNamed: 'tag12'.
	tag21 := model2 tagNamed: 'tag21'.

	self assertCollection: (application tagListForMooseModel: model1) hasSameElements: { tag11 . tag12 }.
	self assertCollection: (application tagListForMooseModel: model2) hasSameElements: { tag21 }.
]

{ #category : #tests }
MiLastTagTest >> testTagListSeveralTags [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model1 tagNamed: 'tag2'.

	self assertCollection: (application tagListForMooseModel: model1) hasSameElements: { tag1 . tag2 }.
]

{ #category : #tests }
MiLastTagTest >> testTagSelectedOneTagSeveralModels [
	| tag |
	tag := model1 tagNamed: 'tag1'.

	application tagSelected: tag forMooseModel: model1.

	self assert: (application tagSelectedForMooseModel: model1) equals: tag.
	self assert: (application tagSelectedForMooseModel: model2) equals: nil.
]

{ #category : #tests }
MiLastTagTest >> testTagSelectedSetAndGet [
	| tag |
	tag := model1 tagNamed: 'tag'.
	
	self assert: (application tagSelectedForMooseModel: model1) equals: nil.

	application tagSelected: tag forMooseModel: model1.
	self assert: (application tagSelectedForMooseModel: model1) equals: tag.
]

{ #category : #tests }
MiLastTagTest >> testTagSelectedSeveralTagsOneModel [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model1 tagNamed: 'tag2'.

	application tagSelected: tag1 forMooseModel: model1.
	self assert: (application tagSelectedForMooseModel: model1) equals: tag1.

	application tagSelected: tag2 forMooseModel: model1.
	self assert: (application tagSelectedForMooseModel: model1) equals: tag2.
]

{ #category : #tests }
MiLastTagTest >> testTagSelectedSeveralTagsSeveralModels [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model2 tagNamed: 'tag2'.

	application tagSelected: tag1 forMooseModel: model1.
	application tagSelected: tag2 forMooseModel: model2.

	self assert: (application tagSelectedForMooseModel: model1) equals: tag1.
	self assert: (application tagSelectedForMooseModel: model2) equals: tag2.
]

{ #category : #tests }
MiLastTagTest >> testTagSelectedTwoTagsTwoModels [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model2 tagNamed: 'tag2'.

	application tagSelected: tag1 forMooseModel: model1.
	application tagSelected: tag2 forMooseModel: model2.

	self assert: (application tagSelectedForMooseModel: model1) equals: tag1.
	self assert: (application tagSelectedForMooseModel: model2) equals: tag2.
]
