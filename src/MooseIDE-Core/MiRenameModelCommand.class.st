Class {
	#name : #MiRenameModelCommand,
	#superclass : #MiModelUtilityCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiRenameModelCommand class >> defaultDescription [
	^ 'Rename this model'
]

{ #category : #default }
MiRenameModelCommand class >> defaultIconName [
	^ #edit
]

{ #category : #default }
MiRenameModelCommand class >> defaultName [
	^ 'Rename'
]

{ #category : #executing }
MiRenameModelCommand >> execute [

	| newName |
	newName := UITheme builder
		           textEntry:
		           'Set new name for MooseModel ' , self model name
		           title: self class defaultName
		           entryText: self model name.
	(newName isNil or: [ newName isEmpty ]) ifTrue: [ ^ self ].
	self model name: newName.
	self context update
]
