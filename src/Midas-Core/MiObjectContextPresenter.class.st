"
I am a subclass of `StObjectContextPresenter`.

I force my initialization to be without the evaluator (the code presenter in the below part of the inspector). This is because in `MiInspectorBrowser` the evaluator is not wanted in any case.
"
Class {
	#name : #MiObjectContextPresenter,
	#superclass : #StObjectContextPresenter,
	#category : #'Midas-Core-Inspector'
}

{ #category : #initialization }
MiObjectContextPresenter >> initializePresenters [

	view := self model newInspectionView.
	self intializePresentersWithoutEvaluator
]
