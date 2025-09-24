"
I am a visualization that displays the structure of a class.
Accepted entities: a famix class.

This visualization is used to understand a class structure and presents dead artifacts within a class.
"
Class {
	#name : 'MiClassBlueprintBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'blueprint'
	],
	#category : 'MooseIDE-ClassBlueprint',
	#package : 'MooseIDE-ClassBlueprint'
}

{ #category : 'world menu' }
MiClassBlueprintBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiClassBlueprintBrowser class >> menuItem [

	^ #ClassBlueprintBrowser
]

{ #category : 'world menu' }
MiClassBlueprintBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 5
]

{ #category : 'instance creation' }
MiClassBlueprintBrowser class >> open [ 
	<script>
	super open
]

{ #category : 'instance creation' }
MiClassBlueprintBrowser class >> title [ 
	^ 'Class Blueprint'
]

{ #category : 'testing' }
MiClassBlueprintBrowser >> canFollowEntity: anObject [

	^ anObject isMooseEntity and: [ anObject isType ]
]

{ #category : 'layout' }
MiClassBlueprintBrowser >> defaultLayout [

	^ self newBoxLayoutTopToBottom
		  add: blueprint;
		  yourself
]

{ #category : 'actions' }
MiClassBlueprintBrowser >> followEntity: anEntity [

	super followEntity: anEntity.

	blueprint
		type: anEntity;
		refresh
]

{ #category : 'initialization' }
MiClassBlueprintBrowser >> initializePresenters [

	blueprint := self instantiate: MiClassBlueprintVisualization
]

{ #category : 'accessing' }
MiClassBlueprintBrowser >> miSelectedItem [

	^ blueprint type
]

{ #category : 'actions' }
MiClassBlueprintBrowser >> updateWindowTitleWith: anEntity [

	self withWindowDo: [ :window |
		window title: 'Blueprint of' , anEntity name ]
]
