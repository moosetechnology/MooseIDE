"
I am the Moose browser that replaces the Pharo playground.

Accepted entities: Anything.

Bindings:
- #receivedEntity: The latest received entity.
- A binding for each model in MooseModel root (with 1st letter lowercase).
See Bindings button.
"
Class {
	#name : #MiPlaygroundBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'playground'
	],
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #accessing }
MiPlaygroundBrowser class >> defaultTitle [ 

	^ 'Moose Playground'
]

{ #category : #'class initialization' }
MiPlaygroundBrowser class >> initialize [
	"Make playground active by default"

	super initialize.
	self register
]

{ #category : #'world menu' }
MiPlaygroundBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ aBuilder
		  item: self menuLabel;
		  parent: #Moose;
		  label: self menuLabel;
		  icon: MooseIcons mooseIcon;
		  help: 'Playground enhanced for usage in Moose';
		  order: MiAbstractBrowser menuPharoToolsPriority + 2;
		  action: [ self open ];
		  withSeparatorAfter;
		  yourself
]

{ #category : #'world menu' }
MiPlaygroundBrowser class >> menuLabel [

	^ 'Moose Playground'
]

{ #category : #'instance creation' }
MiPlaygroundBrowser class >> open [

	<script>
	^ super open
]

{ #category : #'as yet unclassified' }
MiPlaygroundBrowser class >> receivedEntityBindingName [

	^ 'receivedEntity'
]

{ #category : #finalization }
MiPlaygroundBrowser class >> register [
	"Add ourselves to registry. See [Smalltalk tools]"

	<script>
	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
MiPlaygroundBrowser class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"

	registry workspaceTool: self
]

{ #category : #specs }
MiPlaygroundBrowser class >> title [

	^ 'Moose Playground'
]

{ #category : #specs }
MiPlaygroundBrowser class >> windowSize [

	^ StPlaygroundPresenter preferredExtent
]

{ #category : #testing }
MiPlaygroundBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #testing }
MiPlaygroundBrowser >> canPropagate [

	^ true
]

{ #category : #layout }
MiPlaygroundBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: playground;
		  yourself
]

{ #category : #actions }
MiPlaygroundBrowser >> followEntity: anEntity [

	playground firstPage interactionModel addBinding: (WorkspaceVariable
			 key: self class receivedEntityBindingName
			 value: anEntity)
]

{ #category : #initialization }
MiPlaygroundBrowser >> initializePresenters [

	super initializePresenters.
	playground := self instantiate: MiPlayground
]

{ #category : #inspecting }
MiPlaygroundBrowser >> miInspect [

	MiInspectorBrowser inspect: playground firstPage evaluate
]

{ #category : #accessing }
MiPlaygroundBrowser >> miSelectedItem [

	^ playground firstPage evaluate
]
