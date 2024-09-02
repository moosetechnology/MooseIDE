Class {
	#name : #MiCriticBrowserToolsTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'browser'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #testing }
MiCriticBrowserToolsTest class >> isAbstract [

	^ self == MiCriticBrowserToolsTest
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUp [

	super setUp.
	browser := MiCriticBrowser openForTests: self application
]

{ #category : #running }
MiCriticBrowserToolsTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]
