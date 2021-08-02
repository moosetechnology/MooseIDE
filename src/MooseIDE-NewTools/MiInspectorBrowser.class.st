"
I am a custom MooseIDE inspector. I have as a sub-presenter an instance of `MiInspectorPresenter` which is at the same time a subclass of `StInspector`. I am just like Pharo's inspector just that I am connected to the `MiApplication` bus.
I have implemented the methods: `followAction` and `miSelectedItem` in order to listen and propagate entries to the bus.
"
Class {
	#name : #MiInspectorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'miInspector'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #specs }
MiInspectorBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #miInspector;
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
	newInstance openWithSpec.
	buses do: [ :aBus | newInstance followBus: aBus ].
	^ newInstance
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Inspector)
		parent: #Moose;
		label: self title;
		icon: (self iconNamed: #smallInspectIt);
		order: 5;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> newModel [

	^ MooseModel root entities
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> open [

	<script>
	^ super open
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
	miInspector model: self model.
	self updateWindowTitle: self window
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	super initializePresenters.
	miInspector := self instantiate: MiInspector on: self model
]

{ #category : #initialization }
MiInspectorBrowser >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	self updateWindowTitle: aWindow
]

{ #category : #accessing }
MiInspectorBrowser >> miSelectedItem [

	| lastInspectorPage |
	lastInspectorPage := miInspector millerList pages last.
	^ lastInspectorPage model inspectedObject
]

{ #category : #initialization }
MiInspectorBrowser >> updateWindowTitle: aWindow [

	| title |
	title := self class title , ' on {1}' format:
		         { ([ self model displayString ]
			          on: Error
			          do: [ :e | e printString ]) }.
	aWindow ifNotNil: [ aWindow title: title ]
]
