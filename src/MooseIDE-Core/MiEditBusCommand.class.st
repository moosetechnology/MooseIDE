Class {
	#name : #MiEditBusCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
MiEditBusCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : #execution }
MiEditBusCommand >> execute [

	self context openBusEditor
]
