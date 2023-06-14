"
An AbstractSeverityTest is a test class for testing the behavior of AbstractSeverity
"
Class {
	#name : #AbstractSeverityTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #tests }
AbstractSeverityTest >> testLevelValueIsDifferentForEverySubclass [

	| levels |
	levels := AbstractSeverity allSubclasses collect: [ :subclass |
		          subclass level ].

	levels do: [ :lvl |
		self assert: (lvl class inheritsFromOrEqualTo: Integer) equals: true ].
	self assert: levels size = levels asSet size equals: true
]
