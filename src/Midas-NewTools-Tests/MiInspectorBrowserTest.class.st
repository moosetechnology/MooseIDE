"
A MiInspectorBrowserTest is a test class for testing the behavior of MiInspectorBrowser
"
Class {
	#name : #MiInspectorBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'Midas-NewTools-Tests-Inspector'
}

{ #category : #'tests - actions' }
MiInspectorBrowserTest >> assertFollowActionFor: aMooseObject [

	self assert: browser miInspector model equals: aMooseObject
	
]

{ #category : #running }
MiInspectorBrowserTest >> browserClass [

	^ MiInspectorBrowser
]
