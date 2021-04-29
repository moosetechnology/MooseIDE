Class {
	#name : #MiStObjectInspectorPresenter,
	#superclass : #StObjectInspectorPresenter,
	#category : #'Midas-Core-Inspector'
}

{ #category : #'private factory' }
MiStObjectInspectorPresenter >> newInspectionForContext: aContext [

	^ MiStObjectContextPresenter on: (StObjectContextModel new
			   inspection: self model;
			   inspectedObject: self inspectedObject;
			   context: aContext;
			   yourself)
]
