"
I am a custom MooseIDE inspector. I have as a sub-presenter an instance of `MiInspectorPresenter` which is at the same time a subclass of `StInspector`. I am just like Pharo's inspector just that I am connected to the `MiApplication` bus.
I have implemented the methods: `followAction` and `miSelectedItem` in order to listen and propagate entries to the bus.

Accepted entities: a MooseEntity
"
Class {
	#name : #MiInspectorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'miInspector'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #menu }
MiInspectorBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	self addToMiBrowsersMenu: aRootMenu
]

{ #category : #layout }
MiInspectorBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #miInspector;
		  yourself
]

{ #category : #api }
MiInspectorBrowser class >> inspect: anObject [

	^ self
		  inspect: anObject
		  forBuses: self currentApplication defaultBus asCollection
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
MiInspectorBrowser class >> title [

	^ 'Moose Inspector'
]

{ #category : #specs }
MiInspectorBrowser class >> windowSize [

	^ 700 @ 500
]

{ #category : #testing }
MiInspectorBrowser >> canFollowEntity: anEntity [

	"Returns true because all object can be inspected with this Midas inspector. It can be changed in future acording to new needs."

	^ true
]

{ #category : #actions }
MiInspectorBrowser >> followEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self model entity: anEntity.
	miInspector model: self model entity.
	self updateWindowTitle: self window.
	self updateToolbar
]

{ #category : #initialization }
MiInspectorBrowser >> initializePresenters [

	miInspector := self instantiate: MiInspector on: self model entity
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
		         { ([ self model entity displayString ]
			          on: Error
			          do: [ :e | e printString ]) }.
	aWindow ifNotNil: [ aWindow title: title ]
]
