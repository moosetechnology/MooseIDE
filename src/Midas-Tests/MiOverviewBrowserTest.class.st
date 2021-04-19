Class {
	#name : #MiOverviewBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'Midas-Tests-Browsers'
}

{ #category : #running }
MiOverviewBrowserTest >> browserClass [
	^ MiOverviewBrowser
]

{ #category : #running }
MiOverviewBrowserTest >> selectMenu: aMenu item: anIndex [
	"simulating a click on an item of the SpMenuBarPresenter
	not too sure of what I am doing here"
	| menuItem |
	menuItem := (aMenu menuGroups first menuItems first subMenu menuGroups flatCollect: #menuItems) at: anIndex.
	^menuItem performMenuActionWith: menuItem
]

{ #category : #running }
MiOverviewBrowserTest >> setUp [
	super setUp.
	browser := self browserClass runMe
]

{ #category : #running }
MiOverviewBrowserTest >> tearDown [
	browser application reset.
	super tearDown
]

{ #category : #'tests - buses' }
MiOverviewBrowserTest >> testCreateBrowserInPage [
	browser chkOpenInPage state: true.
	self assert: browser mainPresenter pages size equals: 2.
	self selectMenu: browser browsersButton item: 2.
	self assert: browser mainPresenter pages size equals: 3.
]

{ #category : #'tests - buses' }
MiOverviewBrowserTest >> testCreateBrowserInWorld [
	browser chkOpenInPage state: false.
	self assert: browser mainPresenter pages size equals: 2.
	self selectMenu: browser browsersButton item: 2.
	self assert: browser mainPresenter pages size equals: 2.
]
