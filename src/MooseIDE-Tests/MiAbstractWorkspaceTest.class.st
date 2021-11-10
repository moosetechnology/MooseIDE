Class {
	#name : #MiAbstractWorkspaceTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #testing }
MiAbstractWorkspaceTest class >> isAbstract [
	^ self == MiAbstractWorkspaceTest
]

{ #category : #tests }
MiAbstractWorkspaceTest >> testPropagatesInsideOut [
	| bus mockEntity |
	mockEntity := MooseEntity new.
	bus := browser buses anyOne.

	browser privateBus globallySelect: mockEntity.
	self assert: bus mostRecentEntity isNil.

	(self actionButton: MiPropagateCommand) execute.
	self assert: bus mostRecentEntity equals: mockEntity.
]
