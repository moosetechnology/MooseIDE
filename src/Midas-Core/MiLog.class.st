Class {
	#name : #MiLog,
	#superclass : #Object,
	#instVars : [
		'logger'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #activation }
MiLog >> activate [
	self subclassResponsibility
]

{ #category : #activation }
MiLog >> application [
	^ self logger application
]

{ #category : #accessing }
MiLog >> logger [
	^ logger
]

{ #category : #accessing }
MiLog >> logger: anObject [
	logger := anObject
]
