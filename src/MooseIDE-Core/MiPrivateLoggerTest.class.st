Class {
	#name : #MiPrivateLoggerTest,
	#superclass : #TestCase,
	#instVars : [
		'logger'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #running }
MiPrivateLoggerTest >> setUp [

	super setUp.
	logger := MiPrivateLogger new
]
