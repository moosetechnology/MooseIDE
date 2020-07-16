Class {
	#name : #MiBusPresenter,
	#superclass : #MiMidasItemPresenter,
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiBusPresenter class >> tableHeight [
	^ self currentApplication browsers size * self tableLineHeight
]

{ #category : #settings }
MiBusPresenter >> tableCheckBoxEvaluation [
	^ [ :browser | browser buses includes: model ]
]

{ #category : #settings }
MiBusPresenter >> tableItems [
	^ self application browsers asOrderedCollection
]

{ #category : #settings }
MiBusPresenter >> tableStringEvaluation [
	^ [ :browser | browser title ]
]

{ #category : #settings }
MiBusPresenter >> toolbarLabel [
	^ model name
]
