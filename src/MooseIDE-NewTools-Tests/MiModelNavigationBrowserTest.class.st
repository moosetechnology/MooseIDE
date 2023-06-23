Class {
	#name : #MiModelNavigationBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'miInspectorBrowser'
	],
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #running }
MiModelNavigationBrowserTest >> setUp [

	super setUp.

	miInspectorBrowser := MiInspectorBrowser openForTests:
		               MiTestApplication current
]

{ #category : #running }
MiModelNavigationBrowserTest >> tearDown [

	miInspectorBrowser window close.
	super tearDown
]

{ #category : #tests }
MiModelNavigationBrowserTest >> testClickingOpensMooseGroup [

	"This test passes locally but fails on SmalltalkCI because MiModelNavigationBrowser fails to be implemented.
	The error is a primitive failure in #inspectorPerform:"
	| inspectedModel |
	inspectedModel := FamixStModel new
		                  newClassNamed: #C1;
		                  newClassNamed: #C2;
		                  yourself.
	miInspectorBrowser followEntity: inspectedModel.

	self assert: miInspectorBrowser miSelectedItem equals: inspectedModel.


	miInspectorBrowser miInspector firstPagePresenter navigation
		clickAtIndex: 8.

	self
		assert: miInspectorBrowser miSelectedItem
		equals: inspectedModel allClasses
]
