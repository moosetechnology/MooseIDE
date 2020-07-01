Class {
	#name : #MiApplicationTest,
	#superclass : #TestCase,
	#category : #'Midas-Tests'
}

{ #category : #tests }
MiApplicationTest >> testDefault [
	| default |
	default := MiApplication default.
	self assert: default class identicalTo: MiApplication
]

{ #category : #tests }
MiApplicationTest >> testNamed [
	| newApp |
	newApp := MiApplication named: 'TestApp'.
	self assert: newApp class identicalTo: MiApplication
]
