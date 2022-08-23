"
I am a browser that display a hieracical map.
"
Class {
	#name : #MiArchitecturalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapBrowser class >> mapClass [

	^ MiArchitecturalMap
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuItem [

	^ #MiArchitecturalMapBrowser
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 1
]

{ #category : #'instance creation' }
MiArchitecturalMapBrowser class >> newModel [

	^ MiArchitecturalMapModel new
]

{ #category : #'instance creation' }
MiArchitecturalMapBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiArchitecturalMapBrowser class >> title [

	^ 'Architectural map'
]

{ #category : #specs }
MiArchitecturalMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #actions }
MiArchitecturalMapBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : #actions }
MiArchitecturalMapBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiArchitecturalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> canvas [

	^ visualization canvas
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> fetchTags [

	^ (self application itemsFor: FamixTag) asOrderedCollection
]

{ #category : #actions }
MiArchitecturalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self runVisualization
]

{ #category : #testing }
MiArchitecturalMapBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> run [

	visualization run
]

{ #category : #actions }
MiArchitecturalMapBrowser >> runVisualization [ 

	visualization run
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> setModelBeforeInitialization: aModel [

	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> settings [

	^model openSettings
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> visualization [

	^ visualization
]
