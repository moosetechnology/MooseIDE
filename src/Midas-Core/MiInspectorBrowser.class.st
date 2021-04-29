Class {
	#name : #MiInspectorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'stInspector'
	],
	#category : #'Midas-Core-Inspector'
}

{ #category : #specs }
MiInspectorBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #stInspector;
		  yourself
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> newModel [

	^ MooseModel root entities
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> runMe [

	<script>
	^ super runMe
]

{ #category : #specs }
MiInspectorBrowser class >> title [

	^ 'Midas Inspector'
]

{ #category : #specs }
MiInspectorBrowser class >> windowSize [

	^ 700 @ 450
]

{ #category : #actions }
MiInspectorBrowser >> followAction [

	stInspector model: toSelect
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	super initializePresenters.
	stInspector := self instantiate: MiInspector.
	stInspector model: self model
]

{ #category : #accessing }
MiInspectorBrowser >> miSelectedItem [

	| lastInspectorPage |
	lastInspectorPage := stInspector millerList pages last.
	^ lastInspectorPage model inspectedObject
]

{ #category : #accessing }
MiInspectorBrowser >> stInspector [

	^ stInspector
]
