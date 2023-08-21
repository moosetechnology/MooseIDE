Class {
	#name : #MiPreviewModel,
	#superclass : #Object,
	#instVars : [
		'queries',
		'mooseModel'
	],
	#category : #'MooseIDE-Preview-Browser'
}

{ #category : #accessing }
MiPreviewModel >> mooseModel [

	^ mooseModel
]

{ #category : #accessing }
MiPreviewModel >> mooseModel: anObject [

	mooseModel := anObject
]
