"
A MooseIDE browser showing a DSM (Dependency Structural Matrix)
"
Class {
	#name : #MiDSMBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #specs }
MiDSMBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuItem [

	^ #DSMVisualisationBrowser
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuLabel [

	^ 'Dependency Structural Matrix'
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 4
]

{ #category : #'instance creation' }
MiDSMBrowser class >> newModel [
	^MiDSMBrowserModel new
]

{ #category : #'instance creation' }
MiDSMBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiDSMBrowser class >> title [

	^ 'DSM'
]

{ #category : #api }
MiDSMBrowser >> buildDSM [
	diagram run
]

{ #category : #testing }
MiDSMBrowser >> canFollowEntity: anObject [

	^model canFollowEntity: anObject
]

{ #category : #testing }
MiDSMBrowser >> canHighlight [

	^ true
]

{ #category : #accessing }
MiDSMBrowser >> diagram [

	^ diagram
]

{ #category : #actions }
MiDSMBrowser >> followEntity: anEntity [
	model followEntity: anEntity
]

{ #category : #actions }
MiDSMBrowser >> highlightEntity: anEntity [

	model highlightEntity: anEntity
]

{ #category : #initialization }
MiDSMBrowser >> initializePresenters [

	diagram := self instantiate: MiDSMVisualization.
	diagram viewModel: model
]

{ #category : #accessing }
MiDSMBrowser >> miSelectedItem [

	^model selectedEntities
]

{ #category : #api }
MiDSMBrowser >> showSCC: aCollection [
	diagram showSCC: aCollection 
]
