"
An AbstractSeverityTest is a test class for testing the behavior of AbstractSeverity
"
Class {
	#name : #MiCBAbstractSeverityTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #tests }
MiCBAbstractSeverityTest >> testLevelValueIsDifferentForEverySubclass [

	| levels |
	levels := FamixCBAbstractSeverity allSubclasses collect: [ :subclass |
		          subclass level ].

	levels do: [ :lvl |
		self assert: (lvl class inheritsFromOrEqualTo: Integer) equals: true ].
	self assert: levels size = levels asSet size equals: true
]
