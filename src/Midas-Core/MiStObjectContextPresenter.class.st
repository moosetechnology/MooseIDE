Class {
	#name : #MiStObjectContextPresenter,
	#superclass : #StObjectContextPresenter,
	#category : #'Midas-Core-Inspector'
}

{ #category : #initialization }
MiStObjectContextPresenter >> initializePresenters [

	view := self model newInspectionView.
	self intializePresentersWithoutEvaluator
]
