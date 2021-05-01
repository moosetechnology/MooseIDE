"
I am a custom Midas inspector. I have as a sub-presenter an instance of `MiInspectorPresenter` which is at the same time a subclass of `StInspector`. I am just like Pharo's inspector just that I am connected to the `MiApplication` bus.
I have implemented the methods: `followAction` and `miSelectedItem` in order to listen and propagate entries to the bus.
"
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

{ #category : #testing }
MiInspectorBrowser >> accept: anEntity [

	"Returns true because I think that all object can be inspected with this Midas inspector. It can be changed in future acording to new needs."

	^ true
]

{ #category : #actions }
MiInspectorBrowser >> followAction [

	(self accept: toSelect) ifFalse: [ ^ self ].
	stInspector model: toSelect
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	super initializePresenters.
	stInspector := self instantiate: MiInspectorPresenter.
	stInspector model: self model
]

{ #category : #accessing }
MiInspectorBrowser >> miSelectedItem [

	| lastInspectorPage |
	lastInspectorPage := stInspector millerList pages last.
	^ lastInspectorPage model inspectedObject
]
