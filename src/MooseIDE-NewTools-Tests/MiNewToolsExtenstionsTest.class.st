Class {
	#name : #MiNewToolsExtenstionsTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-NewTools-Tests'
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
