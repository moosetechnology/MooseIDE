"
This browser shows dependencies between ""container entities"" (e.g. methods) and ""used entities"" (e.g. attributes) and it allows to mark entities with tags.
Use this browser with a moose collection entity.
Use settings to configure it.
In order to navigate across the visualization

Controls:

* Mouse over, to highlight common inner boxes
* Mouse click, to keep the highlight
* right click over a box, to use the menu
* right click over the view to use the general menu
* command+click to use the last tag.

* Mouse left drag
* Arrrow keys to move the visualization around
* Scrolls bars, to change the view's position
* M, to collapse or expand the window
* I, to zoom in
* O, to zoom out
* Moouse Wheel, to zoom in/out
* S, to search entities on their names (several search can be applied)
* R, to reset (remove) all previous searches
"
Class {
	#name : #MiCoUsageMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'coUsageMap',
		'collectionModel'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #layout }
MiCoUsageMapBrowser class >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		add: #coUsageMap;
		yourself
]

{ #category : #'world menu' }
MiCoUsageMapBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #FilesBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageMapBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiCoUsageMapBrowser class >> title [ 
	^ 'Co Usage Map'
]

{ #category : #specs }
MiCoUsageMapBrowser class >> windowSize [
	^ 800@600
]

{ #category : #'window control' }
MiCoUsageMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: coUsageMap.
	application unregisterProducer: coUsageMap
]

{ #category : #testing }
MiCoUsageMapBrowser >> canFollowEntity: anEntity [
	^ anEntity isCollection and: [ anEntity isMooseModel not ]
]

{ #category : #accessing }
MiCoUsageMapBrowser >> coUsageMap [
	^ coUsageMap
]

{ #category : #accessing }
MiCoUsageMapBrowser >> collectionModel [
	^ collectionModel
]

{ #category : #accessing }
MiCoUsageMapBrowser >> collectionModel: anObject [
	collectionModel := anObject
]

{ #category : #actions }
MiCoUsageMapBrowser >> followEntity: anEntity [
	self collectionModel: anEntity.
	coUsageMap run
]

{ #category : #testing }
MiCoUsageMapBrowser >> hasSettings [ 
	^ true
]

{ #category : #initialization }
MiCoUsageMapBrowser >> initializePresenters [
	coUsageMap := self instantiate: MiCoUsageMapVisualization.
	application registerConsumer: coUsageMap for: FamixTag.
	application registerConsumer: coUsageMap for: FamixTagAssociation.
	application registerProducer: coUsageMap for: FamixTagAssociation.
]

{ #category : #actions }
MiCoUsageMapBrowser >> miSelectedItem [
	^ collectionModel
]

{ #category : #dependencies }
MiCoUsageMapBrowser >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #actions }
MiCoUsageMapBrowser >> settings [ 
	^ coUsageMap openSettingsBrowser
]
