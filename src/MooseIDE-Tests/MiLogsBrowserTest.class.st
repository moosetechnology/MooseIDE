Class {
	#name : 'MiLogsBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#instVars : [
		'newBrowser'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiLogsBrowserTest >> browserClass [

	^ MiLogsBrowser
]

{ #category : 'running' }
MiLogsBrowserTest >> receiveEntityToSelect [

	self application miPropagate: entityToSelect
]

{ #category : 'running' }
MiLogsBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : 'tests' }
MiLogsBrowserTest >> testActivateActionButtons [
	" test that the top toolbar buttons are not activated by default
	 (because there is not selection by default)"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self deny: button isEnabled ]
]

{ #category : 'tests' }
MiLogsBrowserTest >> testActivateActionButtonsAfterSelection [
	" test that the top toolbar buttons are activated after some entry is selected"

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.
	(browser getSelectedPage) activePresenter getDisplayedList clickAtIndex: 1.

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : 'tests' }
MiLogsBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : 'tests' }
MiLogsBrowserTest >> testMiSelectedItem [
	"Test that when there is no selection, selectedItem is empty
	 even after propagating something"

	self assert: browser miSelectedItem isEmpty.

	self receiveEntityToSelect.

	self assert: browser miSelectedItem isEmpty
]

{ #category : 'tests' }
MiLogsBrowserTest >> testMiSelectedItemAfterSelection [
	"Test that when there is a selection, the selectedItem contains it"

	self assert: browser miSelectedItem isEmpty.

	self receiveEntityToSelect.
	(browser getSelectedPage) activePresenter getDisplayedList clickAtIndex: 1.

	self assertCollection: browser miSelectedItem hasSameElements: {entityToSelect}
]
