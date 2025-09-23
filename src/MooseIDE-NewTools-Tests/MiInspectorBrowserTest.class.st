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

	self assert: browser miInspector model equals: aMooseObject
	
]

{ #category : #running }
MiInspectorBrowserTest >> browserClass [

	^ MiInspectorBrowser
]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseEntity [

	browser followEntity: MooseEntity new.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseGroup [

	browser followEntity: self mooseObjects asMooseGroup.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : #'tests - tags' }
MiInspectorBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]
