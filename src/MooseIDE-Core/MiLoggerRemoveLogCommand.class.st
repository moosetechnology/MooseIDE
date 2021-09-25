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
