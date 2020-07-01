Class {
	#name : #MiApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Midas-Tests'
}

{ #category : #running }
MiApplicationTest >> alternativeApplicationName [
	^ 'TestApp2'
]

{ #category : #running }
MiApplicationTest >> applicationName [
	^ 'TestApp'
]

{ #category : #running }
MiApplicationTest >> setUp [
	super setUp.
	application := MiApplication named: self applicationName
]

{ #category : #running }
MiApplicationTest >> tearDown [
	MiApplication
		deleteApplicationNamed: self applicationName;
		deleteApplicationNamed: self alternativeApplicationName.
	super tearDown
]

{ #category : #tests }
MiApplicationTest >> testDefault [
	| default |
	default := MiApplication default.
	self assert: default class identicalTo: MiApplication
]

{ #category : #tests }
MiApplicationTest >> testDeleteApplicationNamed [
	| initialSize |
	initialSize := MiApplication registry size.
	
	MiApplication deleteApplicationNamed: self applicationName.
	
	self deny: (MiApplication registry includesKey: self applicationName).
	self assert: MiApplication registry size equals: initialSize - 1
]

{ #category : #tests }
MiApplicationTest >> testNamed [
	| initialSize newApp |
	initialSize := MiApplication registry size.
	newApp := MiApplication named: self alternativeApplicationName.
	
	self assert: newApp class identicalTo: MiApplication.
	self assert: MiApplication registry size equals: initialSize + 1.
]
