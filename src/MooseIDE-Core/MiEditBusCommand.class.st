Class {
	#name : #MiEditBusCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
MiEditBusCommand class >> defaultDescription [

	^ 'Edit buses'
]

{ #category : #initialization }
MiEditBusCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : #converting }
MiEditBusCommand >> asSpecCommand [

	^ super asSpecCommand
		  name: 'Default';
		  yourself
]

{ #category : #execution }
MiEditBusCommand >> execute [

	self context openBusEditor
]
