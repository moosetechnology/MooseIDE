Class {
	#name : #MiPlaygroundBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'playground'
	],
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #'instance creation' }
MiPlaygroundBrowser class >> open [

	<script>
	^ super open
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

	playground firstPage text interactionModel addBinding:
		(WorkspaceVariable
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
