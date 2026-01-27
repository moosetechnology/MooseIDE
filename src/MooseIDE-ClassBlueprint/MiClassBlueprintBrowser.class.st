"
I am a visualization that displays the structure of a class.
Accepted entities: a famix class.

This visualization is used to understand a class structure and presents dead artifacts within a class.
"
Class {
	#name : 'MiClassBlueprintBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'MooseIDE-ClassBlueprint',
	#package : 'MooseIDE-ClassBlueprint'
}

{ #category : 'accessing' }
MiClassBlueprintBrowser class >> mapClass [

	^ MiClassBlueprintVisualization
]

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
MiClassBlueprintBrowser class >> newModel [

	^ MiClassBlueprintModel new
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

	^ anObject usesFamixTrait: FamixTType
]

{ #category : 'actions' }
MiClassBlueprintBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel currentType: anEntity.
	self runVisualization
]

{ #category : 'actions' }
MiClassBlueprintBrowser >> updateWindowTitleWith: anEntity [

	self withWindowDo: [ :window |
		window title: 'Blueprint of' , anEntity name ]
]
