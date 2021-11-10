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
	bus stub.

	browser privateBus globallySelect: mockEntity.

	"bus should receive globallySelect: mockEntity."
]
