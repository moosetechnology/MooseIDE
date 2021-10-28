Class {
	#name : #MiLoggerClearLogsCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiLoggerClearLogsCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : #default }
MiLoggerClearLogsCommand class >> defaultName [

	^ 'Clear logs'
]

{ #category : #testing }
MiLoggerClearLogsCommand >> canBeExecuted [

	^ self context miSelectedItem isNotNil
]

{ #category : #executing }
MiLoggerClearLogsCommand >> execute [

	self context clearLogs
]
