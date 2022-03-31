"
I am a subclass of `StInspector`.

The only difference between my `newInspectorFor:` method implementation and the one of my superclass, is that mine returns an instance of `MiObjectInspectorPresenter` instead of `StObjectInspectorPresenter`. This is to remove the evaluator (the code presenter of the below part) of the inspector.
(See `StInspector>>#newInspectorFor:`)
"
Class {
	#name : #MiInspector,
	#superclass : #StInspector,
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #initialization }
MiInspector >> initializePresenters [
	super initializePresenters.

	millerList millerListPresenter
		whenColumnsChangedDo: [self owner updateToolbar].
]

{ #category : #'private - factory' }
MiInspector >> newInspectorFor: aModel [

	| newInspector |
	newInspector := self
		                instantiate: MiObjectInspectorPresenter
		                on: aModel asInspectorModel.
	self class inspectorDiveOnSingleClick ifTrue: [ 
		newInspector activateOnSingleClick ].

	millerList pages ifNotEmpty: [ :pages | 
		newInspector
			whenClosedDo: [ millerList removeAllFrom: newInspector ];
			"select last shown page (or default)"trySelectAnyPageWithName: { 
					lastPageSelectedTabName.
					pages last selectedPageName }
		"prepare to close" ].

	^ newInspector
]
