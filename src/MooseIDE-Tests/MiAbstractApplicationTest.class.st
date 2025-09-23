Class {
	#name : 'MiAbstractApplicationTest',
	#superclass : 'TestCase',
	#instVars : [
		'application',
		'previousApplication'
	],
	#category : 'MooseIDE-Tests-Application',
	#package : 'MooseIDE-Tests',
	#tag : 'Application'
}

{ #category : 'accessing' }
MiAbstractApplicationTest >> application [

	^ application
]

{ #category : 'running' }
MiAbstractApplicationTest >> setUp [

	super setUp.
	previousApplication := MiApplication current.
	previousApplication unregisterForDropFilesEvent.

	application := MiTestApplication new.
	MiApplication current: application
]

{ #category : 'running' }
MiAbstractApplicationTest >> tearDown [

	MiApplication reset.
	MiApplication current: previousApplication.
	previousApplication beDropFilesHandler.
	super tearDown
]
