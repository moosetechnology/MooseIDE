Class {
	#name : #MiLoggerRemoveLogCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
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

{ #category : #testing }
MiLoggerRemoveLogCommand >> execute [

	^ self context removeSelectedLog
]
