Class {
	#name : #MiTestApplication,
	#superclass : #MiApplication,
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #accessing }
MiTestApplication class >> defaultBusName [

	^ 'Test'
]

{ #category : #'instance creation' }
MiTestApplication class >> new [

	^ self basicNew initialize
]

{ #category : #'drag and drop support' }
MiTestApplication >> importModelFromFile: aStubObject [
	"overriding for tests"
	aStubObject wasHandled
]
