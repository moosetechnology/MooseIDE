Class {
	#name : #MiAbstractTelescopeBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Telescope'
}

{ #category : #'instance creation' }
MiAbstractTelescopeBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #testing }
MiAbstractTelescopeBrowser class >> isAbstract [
	^ self == MiAbstractTelescopeBrowser
]

{ #category : #'instance creation' }
MiAbstractTelescopeBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^ (aBuilder item: self telescopeMenuItemName)
		parent: (self midasBrowserMenuLabel) ;
		order: 50 ;
		label: 'Telescope' ;
		withSeparatorAfter 
]

{ #category : #'instance creation' }
MiAbstractTelescopeBrowser class >> telescopeMenuItemName [
	^ #TelescopeBrowsers
]

{ #category : #initialization }
MiAbstractTelescopeBrowser >> diagramClass [
	"Should return a subclass of MiAbstractVisualization"

	^ self subclassResponsibility
]

{ #category : #initialization }
MiAbstractTelescopeBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: self diagramClass
]
