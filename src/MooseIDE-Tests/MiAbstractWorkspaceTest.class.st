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
MiAbstractWorkspaceTest >> testFollowModePropagatesOutsideBusToPrivateBus [
	| bus mockEntity |
	mockEntity := MooseEntity new.
	bus := browser buses anyOne.
	browser receivingMode: MiFollowMode.
	browser containedBrowsers do: [ :each | each canReceive: true ].

	bus globallySelect: mockEntity.
	self assert: browser privateBus mostRecentEntity equals: mockEntity.
]

{ #category : #tests }
MiAbstractWorkspaceTest >> testFreezeModeDoesNotPropagateOutsideBusToPrivateBus [
	| bus mockEntity |
	mockEntity := MooseEntity new.
	bus := browser buses anyOne.
	browser receivingMode: MiFreezeMode.
	browser containedBrowsers do: [ :each | each canReceive: true ].

	bus globallySelect: mockEntity.
	self assert: browser privateBus mostRecentEntity isNil.
]

{ #category : #tests }
MiAbstractWorkspaceTest >> testHighlightModePropagatesOutsideBusToPrivateBus [
	| bus mockEntity |
	mockEntity := MooseEntity new.
	bus := browser buses anyOne.
	browser receivingMode: MiHighlightMode.
	browser containedBrowsers do: [ :each | each canReceive: true ].

	bus globallySelect: mockEntity.
	self assert: browser privateBus mostRecentEntity equals: mockEntity.
]

{ #category : #tests }
MiAbstractWorkspaceTest >> testPropagatesPrivateBusToOutsideBus [
	| bus mockEntity |
	mockEntity := MooseEntity new.
	bus := browser buses anyOne.

	browser privateBus globallySelect: mockEntity.
	self assert: bus mostRecentEntity isNil.

	(self actionButton: MiPropagateCommand) execute.
	self assert: bus mostRecentEntity equals: mockEntity.
]
