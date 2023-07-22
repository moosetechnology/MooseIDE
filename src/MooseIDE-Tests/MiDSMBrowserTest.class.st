Class {
	#name : #MiDSMBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDSMBrowserTest >> browserClass [
	^ MiDSMBrowser
]

{ #category : #running }
MiDSMBrowserTest >> method: aName [

	^ FamixRepTestMethod named: aName
]

{ #category : #running }
MiDSMBrowserTest >> setUp [
	super setUp.

	entityToSelect := { self method: 'method1' . self method: 'method2' . self method: 'method3' }
]

{ #category : #tests }
MiDSMBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self flag: 'not sure whether we should have actions in DSM ?'.
	"browser receiveEntity: (MooseGroup with: entityToSelect).
	browser actionButtons do: [ :button | self assert: button isEnabled ]."

]

{ #category : #'tests - tags' }
MiDSMBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]
