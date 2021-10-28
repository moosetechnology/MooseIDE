Class {
	#name : #MiLoggerRemoveLogCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiLoggerRemoveLogCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : #default }
MiLoggerRemoveLogCommand class >> defaultName [

	^ 'Remove selected log'
]

{ #category : #testing }
MiLoggerRemoveLogCommand >> canBeExecuted [

	^ self context miSelectedItem isNotNil
]

{ #category : #executing }
MiLoggerRemoveLogCommand >> execute [

	^ self context removeSelectedLog
]
