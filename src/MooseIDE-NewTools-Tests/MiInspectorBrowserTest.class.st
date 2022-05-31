"
A MiInspectorBrowserTest is a test class for testing the behavior of MiInspectorBrowser
"
Class {
	#name : #MiInspectorBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #'tests - actions' }
MiInspectorBrowserTest >> assertFollowActionFor: aMooseObject [

	self assert: browser containedBrowser miInspector model equals: aMooseObject
	
]

{ #category : #running }
MiInspectorBrowserTest >> browserClass [

	^ MiInspectorBrowser
]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseEntity [

	browser followEntity: MooseEntity new.

	self assert: browser canPropagate.
	self assert: (self actionButton: MiPropagateCommand) isEnabled
]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseGroup [

	browser followEntity: self mooseObjects asMooseGroup.

	self assert: browser canPropagate.
	self assert: (self actionButton: MiPropagateCommand) isEnabled
]

{ #category : #tests }
MiInspectorBrowserTest >> testCannotPropagatePharoCollection [

	browser followEntity: self mooseObjects.

	self deny: browser canPropagate.
	self deny: (self actionButton: MiPropagateCommand) isEnabled
]

{ #category : #tests }
MiInspectorBrowserTest >> testPropagateRightPane [

	| entity |
	entity := MooseEntity new.

	browser followEntity: (MooseModel new
			 add: entity;
			 yourself).

	"Select entity on the first page, to open it in a second page"
	browser containedBrowser miInspector millerList millerListPresenter
		changeSelection: entity
		from: browser containedBrowser miInspector firstPage.

	self assert: browser miSelectedItem equals: entity
]
