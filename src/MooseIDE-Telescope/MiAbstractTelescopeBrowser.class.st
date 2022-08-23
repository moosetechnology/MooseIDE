Class {
	#name : #MiAbstractTelescopeBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Telescope-Butterfly'
}

{ #category : #specs }
MiAbstractTelescopeBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #diagram;
		yourself
]

{ #category : #testing }
MiAbstractTelescopeBrowser class >> isAbstract [
	^ self == MiAbstractTelescopeBrowser
]

{ #category : #'world menu' }
MiAbstractTelescopeBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^ (aBuilder item: self telescopeMenuItemName)
		parent: (self midasBrowserMenuLabel) ;
		order: 50 ;
		label: 'Telescope' ;
		withSeparatorAfter 
]

{ #category : #'world menu' }
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

	diagram := self instantiate: self diagramClass
]
