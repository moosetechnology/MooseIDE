Class {
	#name : #MiModelNavigationBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'miInspector'
	],
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #running }
MiModelNavigationBrowserTest >> setUp [

	super setUp.

	miInspector := MiInspectorBrowser openForTests:
		               MiTestApplication current
]

{ #category : #running }
MiModelNavigationBrowserTest >> tearDown [
"
	miInspector window close."
	super tearDown
]

{ #category : #tests }
MiModelNavigationBrowserTest >> testClickingOpensMooseGroup [

	| inspectedModel navigationList |
	inspectedModel := FamixStModel new
		                  newClassNamed: #C1;
		                  newClassNamed: #C2;
		                  yourself.
	miInspector followEntity: inspectedModel.

	self
		assert: miInspector miInspector firstPage inspectedObject
		equals: inspectedModel.

	navigationList := (miInspector miInspector firstPage selectedPage
		                   activePresenter presenterAt: #view) presenter
		                  presenterAt: #navigation.
	navigationList clickAtIndex: 8.

	self
		assert: miInspector miSelectedItem
		equals: inspectedModel allClasses
]
