Class {
	#name : #MiDeleteModelCommand,
	#superclass : #MiModelUtilityCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiDeleteModelCommand class >> defaultDescription [
	^ 'Delete this model'
]

{ #category : #defaults }
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
	self context update
]
