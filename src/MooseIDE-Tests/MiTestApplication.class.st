"
An application for Moose IDE tests
"
Class {
	#name : 'MiTestApplication',
	#superclass : 'MiApplication',
	#category : 'MooseIDE-Tests-Application',
	#package : 'MooseIDE-Tests',
	#tag : 'Application'
}

{ #category : 'accessing' }
MiTestApplication class >> defaultBusName [
	^ 'Test'
]

{ #category : 'drag and drop support' }
MiTestApplication >> importModelFromFile: aStubObject [
	"overriding for tests"
	aStubObject wasHandled
]
