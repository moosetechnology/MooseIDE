Class {
	#name : #MiAbstractApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #accessing }
MiAbstractApplicationTest >> application [
 	^application
]

{ #category : #running }
MiAbstractApplicationTest >> setUp [

	  super setUp.
	  application := MiTestApplication new.
]

{ #category : #running }
MiAbstractApplicationTest >> tearDown [

	self application unregisterForDropFilesEvent.
	super tearDown.

]
