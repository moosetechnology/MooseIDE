Class {
	#name : #MiFilesModel,
	#superclass : #Object,
	#instVars : [
		'mooseModel'
	],
	#category : #'Midas-Famix-FilesBrowser'
}

{ #category : #accessing }
MiFilesModel >> mooseModel [
	^ mooseModel
]

{ #category : #accessing }
MiFilesModel >> mooseModel: anObject [
	mooseModel := anObject
]
