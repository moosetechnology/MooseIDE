Class {
	#name : #MiDeleteModelCommand,
	#superclass : #MiModelUtilityCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiDeleteModelCommand class >> defaultDescription [
	^ 'Delete this model'
]

{ #category : #default }
MiDeleteModelCommand class >> defaultIconName [
	^ #smallDelete
]

{ #category : #default }
MiDeleteModelCommand class >> defaultName [
	^ 'Delete'
]

{ #category : #executing }
MiDeleteModelCommand >> execute [
	(UIManager default
		confirm:
			'Are you sure to want to delete ' , self model mooseName printString
				, '?')
		ifFalse: [ ^ self ].
	self model remove.
	self context updateList
]
