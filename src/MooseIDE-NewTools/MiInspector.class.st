"
I am a subclass of `StInspector`.

The only difference between my `newInspectorFor:` method implementation and the one of my superclass, is that mine returns an instance of `MiObjectInspectorPresenter` instead of `StObjectInspectorPresenter`. This is to remove the evaluator (the code presenter of the below part) of the inspector.
(See `StInspector>>#newInspectorFor:`)
"
Class {
	#name : #MiInspector,
	#superclass : #StInspectorPresenter,
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #'inspector compatibility' }
MiInspector >> defaultObjectInspectorClass [

	^ MiObjectInspectorPresenter
]

{ #category : #initialization }
MiInspector >> initializePresenters [

	super initializePresenters.

	millerList millerListPresenter whenColumnsChangedDo: [
		self owner updateToolbar ]
]
