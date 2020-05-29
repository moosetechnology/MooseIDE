Class {
	#name : #MiLoggerRemoveEntryCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiLoggerRemoveEntryCommand class >> defaultName [
	^ 'Remove entry'
]

{ #category : #testing }
MiLoggerRemoveEntryCommand >> canBeExecuted [
	^ self context miSelectedLogEntry isNotNil
]

{ #category : #testing }
MiLoggerRemoveEntryCommand >> execute [
	^ self context removeLog: self context miSelectedLogEntry
]
