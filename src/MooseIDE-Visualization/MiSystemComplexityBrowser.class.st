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
	#category : #'MooseIDE-Visualization'
}

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	^ (aBuilder item: #SystemComplexityBrowser)
		  parent: self midasBrowserMenuLabel;
		  label: self title;
		  help: self helpMessage;
		  order: self menuPriority;
		  action: [ self open ];
		  yourself
]

{ #category : #menu }
MiSystemComplexityBrowser class >> menuPriority [

	^ 6
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

{ #category : #testing }
MiSystemComplexityBrowser >> canFollowEntity: anObject [

	^ anObject isKindOf: FamixTypeGroup
]

{ #category : #actions }
MiSystemComplexityBrowser >> followEntity: aTypeGroup [

	visualization
		types: aTypeGroup;
		run
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

	^ visualization types
]
