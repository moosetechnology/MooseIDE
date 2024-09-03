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

	| inspectedModel |
	inspectedModel := FamixStModel new
		                  newClassNamed: #C1;
		                  newClassNamed: #C2;
		                  yourself.
	miInspectorBrowser followEntity: inspectedModel.

	self assert: miInspectorBrowser miSelectedItem equals: inspectedModel.

	miInspectorBrowser miInspector firstPagePresenter navigation
		clickAtIndex: 1.

	self
		assert: miInspectorBrowser miSelectedItem
		equals: inspectedModel allClasses
]
