"
I am a custom MooseIDE inspector. I have as a sub-presenter an instance of `MiInspectorPresenter` which is at the same time a subclass of `StInspector`. I am just like Pharo's inspector just that I am connected to the `MiApplication` bus.
I have implemented the methods: `followAction` and `miSelectedItem` in order to listen and propagate entries to the bus.

Accepted entities: a MooseEntity
"
Class {
	#name : #MiInspectorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #api }
MiInspectorBrowser class >> inspect: anObject [

	^ self
		  inspect: anObject
		  forBuses: (OrderedCollection with: self currentApplication defaultBus)
]

{ #category : #api }
MiInspectorBrowser class >> inspect: anObject forBuses: buses [

	| newInstance |
	newInstance := self on: (self newModel entity: anObject).
	newInstance open.
	newInstance beFrozen.
	buses do: [ :aBus | newInstance followBus: aBus ].
	^ newInstance
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuIconName [

	^ #smallInspectIt
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuItem [

	^ #Inspector
]

{ #category : #'world menu' }
MiInspectorBrowser class >> menuPriority [

	^ self menuPharoToolsPriority + 1
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> newModel [

	^ MiInspectorModel new
]

{ #category : #'instance creation' }
MiInspectorBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiInspectorBrowser class >> preferredExtent [

	^ 700 @ 500
]

{ #category : #specs }
MiInspectorBrowser class >> title [

	^ 'Moose Inspector'
]

{ #category : #testing }
MiInspectorBrowser >> canFollowEntity: anEntity [

	"Returns true because all object can be inspected with this Midas inspector. It can be changed in future acording to new needs."

	^ true
]

{ #category : #actions }
MiInspectorBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	anEntity ifNil: [ ^ self ].
	self model entity: anEntity.
	mainPresenter model: self model entity.
	self withWindowDo: [ :window | window title: self windowTitle ].
	self updateToolbar
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiInspector on: self model entity
]

{ #category : #accessing }
MiInspectorBrowser >> miSelectedItem [

	| lastInspectorPage |
	lastInspectorPage := mainPresenter millerList pages last.
	^ lastInspectorPage model inspectedObject
]

{ #category : #accessing }
MiInspectorBrowser >> windowTitle [

	^ self windowTitleFor: self model entity
]
