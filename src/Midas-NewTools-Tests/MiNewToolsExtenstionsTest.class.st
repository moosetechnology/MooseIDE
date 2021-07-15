Class {
	#name : #MiNewToolsExtenstionsTest,
	#superclass : #TestCase,
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #tests }
MiNewToolsExtenstionsTest >> testModelMooseInterestingEntity [

	| model storage state |
	model := MooseModel new.
	state := model.
	storage := model entityStorage.

	model mooseInterestingEntity.

	self assert: model identicalTo: state.
	self assert: model entityStorage identicalTo: storage
]
