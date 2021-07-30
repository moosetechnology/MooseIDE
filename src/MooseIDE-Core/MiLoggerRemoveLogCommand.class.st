Class {
	#name : #MiLoggerRemoveLogCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiLoggerRemoveLogCommand class >> defaultName [
	^ 'Remove entry'
]

{ #category : #testing }
MiLoggerRemoveLogCommand >> canBeExecuted [
	^ self context miSelectedLog isNotNil
]

{ #category : #testing }
MiLoggerRemoveLogCommand >> execute [
	^ self context removeLog: self context miSelectedLog
]
