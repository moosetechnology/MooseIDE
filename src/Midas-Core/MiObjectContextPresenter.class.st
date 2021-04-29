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
