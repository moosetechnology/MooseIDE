Class {
	#name : #MiBusLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiBusLogBrowserTest >> browserClass [

	^ MiBusLogBrowser
]

{ #category : #running }
MiBusLogBrowserTest >> receiveEntityToSelect [

	self bus globallySelect: entityToSelect
]

{ #category : #running }
MiBusLogBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiBusLogBrowserTest >> testActivateActionButtons [
	" checks that top toolbar are inactive by default because there is no default selection"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : #tests }
MiBusLogBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiBusLogBrowserTest >> testMiSelectedItem [
	" test that by default there are no selected items"

	self assert: browser miSelectedItem isEmpty.

	self receiveEntityToSelect.

	self assert: browser miSelectedItem isEmpty
]

{ #category : #running }
MiBusLogBrowserTest >> testOpenOnLatestEntity [
	"test that new browser opens on the last selected entity"

	self assert: browser miSelectedItem isEmpty.

	self receiveEntityToSelect.

	newBrowser := self browserClass openForTests: self application.
	newBrowser getDisplayedList clickAtIndex: 1.

	self assertCollection: newBrowser miSelectedItem hasSameElements: {  entityToSelect } 
]
