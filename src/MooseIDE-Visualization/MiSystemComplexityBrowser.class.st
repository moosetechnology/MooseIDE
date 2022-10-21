"
I am a browser showing a System Complexity visualization on classes.
I accept a MooseGroup.
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

	^ anObject isKindOf: MooseGroup
]

{ #category : #actions }
MiSystemComplexityBrowser >> followEntity: aMooseGroup [

	| newGroup |
	newGroup := aMooseGroup select: [ :e | e isClass ].
	newGroup size < aMooseGroup size ifTrue: [ 
		self inform:
			(aMooseGroup size - newGroup size) asString , ' rejected entities.' ].
	model entities: newGroup
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
