Class {
	#name : #MiModelNavigationBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'miInspectorBrowser'
	],
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #tests }
MiModelNavigationBrowserTest >> clickOnAllClasses [
	"Yes, this could be more simple, but it does not work easily on CI"

	| navigationPane |
	navigationPane := self navigationPane navigation.

	navigationPane
		selectItem:
			(navigationPane items detect: [ :item | item key = 'All classes' ]);
		doActivateAtIndex: navigationPane selection selectedIndex
]

{ #category : #tests }
MiModelNavigationBrowserTest >> navigationPane [

	miInspectorBrowser miInspector firstPagePresenter
		traversePresentersDo: [ :presenter |
			presenter class = MiModelNavigationBrowser ifTrue: [ ^ presenter ] ]
]

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
	self clickOnAllClasses.
	self
		assert: miInspectorBrowser miSelectedItem
		equals: inspectedModel allClasses
]
