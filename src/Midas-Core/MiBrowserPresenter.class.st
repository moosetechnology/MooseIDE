Class {
	#name : #MiBrowserPresenter,
	#superclass : #MiMidasItemPresenter,
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiBrowserPresenter class >> tableHeight [
	^ self currentApplication buses size * self tableLineHeight
]

{ #category : #settings }
MiBrowserPresenter >> tableCheckBoxEvaluation [
	^ [ :bus | model buses includes: bus ]
]

{ #category : #settings }
MiBrowserPresenter >> tableItems [
	^ self application buses asOrderedCollection
]

{ #category : #settings }
MiBrowserPresenter >> tableStringEvaluation [
	^ [ :bus | bus name ]
]

{ #category : #settings }
MiBrowserPresenter >> toolbarLabel [
	^ model title
]
