Class {
	#name : #MiTagSelectedTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'model1',
		'model2'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiTagSelectedTest >> setUp [

	super setUp.
	model1 := MooseModel new.
	model2 := MooseModel new.
]

{ #category : #tests }
MiTagSelectedTest >> testSelectedTagSetAndGet [
	| tag |
	tag := model1 tagNamed: 'tag'.
	
	self assert: (application tagSelectedInMooseModel: model1) equals: nil.

	application selectedTag: tag.
	self assert: (application tagSelectedInMooseModel: model1) equals: tag.
]

{ #category : #tests }
MiTagSelectedTest >> testTagListNoModels [

	self assert: (application tagListForMooseModel: nil) isEmpty.
]

{ #category : #tests }
MiTagSelectedTest >> testTagListNoTags [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model1 tagNamed: 'tag2'.

	self assertCollection: (application tagListForMooseModel: model1) hasSameElements: { tag1 . tag2 }.
]

{ #category : #tests }
MiTagSelectedTest >> testTagListSeveralModels [
	| tag11 tag12 tag21 |
	tag11 := model1 tagNamed: 'tag11'.
	tag12 := model1 tagNamed: 'tag12'.
	tag21 := model2 tagNamed: 'tag21'.

	self assertCollection: (application tagListForMooseModel: model1) hasSameElements: { tag11 . tag12 }.
	self assertCollection: (application tagListForMooseModel: model2) hasSameElements: { tag21 }.
]

{ #category : #tests }
MiTagSelectedTest >> testTagListSeveralTags [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model1 tagNamed: 'tag2'.

	self assertCollection: (application tagListForMooseModel: model1) hasSameElements: { tag1 . tag2 }.
]

{ #category : #tests }
MiTagSelectedTest >> testTagSelectedNoModel [

	self assert: (application tagSelectedInMooseModel: nil) equals: nil.

]

{ #category : #tests }
MiTagSelectedTest >> testTagSelectedOneTagSeveralModels [
	| tag |
	tag := model1 tagNamed: 'tag1'.

	application selectedTag: tag.

	self assert: (application tagSelectedInMooseModel: model1) equals: tag.
	self assert: (application tagSelectedInMooseModel: model2) equals: nil.
]

{ #category : #tests }
MiTagSelectedTest >> testTagSelectedSetNeedsModel [
	| tag |
	tag := model1 tagNamed: 'tag1'.

	application selectedTag: tag.

	self assert: (application tagSelectedInMooseModel: nil) equals: nil.

]

{ #category : #tests }
MiTagSelectedTest >> testTagSelectedSeveralTagsOneModel [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model1 tagNamed: 'tag2'.

	application selectedTag: tag1.
	self assert: (application tagSelectedInMooseModel: model1) equals: tag1.

	application selectedTag: tag2.
	self assert: (application tagSelectedInMooseModel: model1) equals: tag2.
]

{ #category : #tests }
MiTagSelectedTest >> testTagSelectedSeveralTagsSeveralModels [
	| tag1 tag2 |
	tag1 := model1 tagNamed: 'tag1'.
	tag2 := model2 tagNamed: 'tag2'.

	application selectedTag: tag1.
	application selectedTag: tag2.

	self assert: (application tagSelectedInMooseModel: model1) equals: tag1.
	self assert: (application tagSelectedInMooseModel: model2) equals: tag2.
]
