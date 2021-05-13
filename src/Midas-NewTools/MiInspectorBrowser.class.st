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
	#category : #'Midas-NewTools-Inspector'
}

{ #category : #specs }
MiInspectorBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #stInspector;
		  yourself
]

{ #category : #api }
MiInspectorBrowser class >> inspect: anObject [

	^ self
		  inspect: anObject
		  forBuses: self currentApplication defaultBus asOrderedCollection
]

{ #category : #api }
MiInspectorBrowser class >> inspect: anObject forBuses: buses [

	| newInstance |
	newInstance := self on: anObject.
	buses do: [ :aBus | newInstance followBus: aBus ].
	^ newInstance openWithSpec
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Inspector)
		parent: #Moose;
		label: self title;
		order: 5;
		help: self helpMessage;
		action: [ self runMe ]
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

	^ 'Moose Inspector'
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
	self model: toSelect.
	stInspector model: self model
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	super initializePresenters.
	stInspector := self instantiate: MiInspector.
	stInspector model: self model
]

{ #category : #initialization }
MiInspectorBrowser >> initializeWindow: aWindow [

	| title |
	super initializeWindow: aWindow.
	title := self class title , ' on {1}' format:
		         { ([ self model displayString ]
			          on: Error
			          do: [ :e | e printString ]) }.
	aWindow title: title
]

{ #category : #accessing }
MiInspectorBrowser >> miSelectedItem [

	| lastInspectorPage |
	lastInspectorPage := stInspector millerList pages last.
	^ lastInspectorPage model inspectedObject
]
