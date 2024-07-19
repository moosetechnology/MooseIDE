Class {
	#name : #MiClassBlueprintBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'blueprint'
	],
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #'instance creation' }
MiClassBlueprintBrowser class >> followEntity: anEntity [ 
	self withWindowDo: [ :window | window title: 'Blueprint of' , anEntity name ].
	
]

{ #category : #'world menu' }
MiClassBlueprintBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiClassBlueprintBrowser class >> menuItem [

	^ #ClassBlueprintBrowser
]

{ #category : #'world menu' }
MiClassBlueprintBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 5
]

{ #category : #'instance creation' }
MiClassBlueprintBrowser class >> open [ 
	<script>
	super open
]

{ #category : #'instance creation' }
MiClassBlueprintBrowser class >> title [ 
	^ 'Class Blueprint'
]

{ #category : #testing }
MiClassBlueprintBrowser >> canFollowEntity: anObject [

	^ anObject isMooseEntity and: [ anObject isType ]
]

{ #category : #testing }
MiClassBlueprintBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	blueprint
		type: anEntity;
		run
]

{ #category : #testing }
MiClassBlueprintBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: blueprint;
			 yourself)
]

{ #category : #initialization }
MiClassBlueprintBrowser >> initializePresenters [

	blueprint := self instantiate: MiClassBlueprintVisualization.
	self initializeLayout
]

{ #category : #testing }
MiClassBlueprintBrowser >> miSelectedItem [ 
	^ blueprint type
]
