"
I am a subclass of `StObjectInspectorPresenter`.

I rewrite `newInspectionForContext:` method only to return an instance of `MiObjectContextPresenter` instead of `StObjectContextPresenter`. It is the only difference. This is to remove the evaluator of the inspector (the evaluator is the code presenter in the below part of the inspector).
(See `StObjectInspectorPresenter>>#newInspectionForContext:`)
"
Class {
	#name : #MiObjectInspectorPresenter,
	#superclass : #StObjectInspectorPresenter,
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #private }
MiObjectInspectorPresenter >> allPages [

	| allPagesWithoutBreakpointsPage |
	"Remove the Breakpoints page in the inspector because is not useful in the Moose Inspector"
	allPagesWithoutBreakpointsPage := super allPages reject: [ :aPage | 
		                                  aPage title = 'Breakpoints' ].
	^ allPagesWithoutBreakpointsPage
]

{ #category : #private }
MiObjectInspectorPresenter >> miBrowser [
	^self owner owner owner owner
]

{ #category : #'private - factory' }
MiObjectInspectorPresenter >> newInspectionForContext: aContext [

	^ MiObjectContextPresenter on: (StObjectContextModel new
			   inspection: self model;
			   inspectedObject: self inspectedObject;
			   context: aContext;
			   yourself)
]

{ #category : #accessing }
MiObjectInspectorPresenter >> refreshContent [

	super refreshContent.
	self miBrowser updateToolbar
]
