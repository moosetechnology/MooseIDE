"
I am a browser showing a System Complexity visualization.
I accept a FamixTypeGroup.
"
Class {
	#name : #MiSystemComplexityBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self buildMenuItemIn: aBuilder) withSeparatorAfter
]

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuItem [

	^ #SystemComplexityBrowser
]

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 6
]

{ #category : #'instance creation' }
MiSystemComplexityBrowser class >> newModel [

	^ MiSystemComplexityModel new
]

{ #category : #'instance creation' }
MiSystemComplexityBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiSystemComplexityBrowser class >> title [

	^ 'System complexity'
]

{ #category : #actions }
MiSystemComplexityBrowser >> buildVisualization [

	visualization run
]

{ #category : #testing }
MiSystemComplexityBrowser >> canFollowEntity: anObject [

	^ anObject isKindOf: FamixTypeGroup
]

{ #category : #actions }
MiSystemComplexityBrowser >> followEntity: aTypeGroup [

	model entities: aTypeGroup
]

{ #category : #actions }
MiSystemComplexityBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiSystemComplexityBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiSystemComplexityBrowser >> initializePresenters [

	visualization := self instantiate: MiSystemComplexity.
	self initializeLayout
]

{ #category : #accessing }
MiSystemComplexityBrowser >> miSelectedItem [

	^ model entities
]

{ #category : #actions }
MiSystemComplexityBrowser >> settings [
	
	model settings open
]
