Class {
	#name : #MiObjectInspectorPresenter,
	#superclass : #StObjectInspectorPresenter,
	#category : #'Midas-Core-Inspector'
}

{ #category : #'private factory' }
MiObjectInspectorPresenter >> newInspectionForContext: aContext [

	^ MiObjectContextPresenter on: (StObjectContextModel new
			   inspection: self model;
			   inspectedObject: self inspectedObject;
			   context: aContext;
			   yourself)
]
