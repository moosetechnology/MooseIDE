Class {
	#name : #MiLoggerClearLogsCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
MiLoggerClearLogsCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : #'accessing - defaults' }
MiLoggerClearLogsCommand class >> defaultName [

	^ 'Clear logs'
]

{ #category : #executing }
MiLoggerClearLogsCommand >> canBeExecuted [

	^ self context miSelectedItem isNotNil
]

{ #category : #executing }
MiLoggerClearLogsCommand >> execute [

	self context clearLogs
]
