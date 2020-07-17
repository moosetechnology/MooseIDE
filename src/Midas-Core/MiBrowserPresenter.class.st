Class {
	#name : #MiBrowserPresenter,
	#superclass : #MiMidasItemPresenter,
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiBrowserPresenter class >> tableHeight [
	^ self currentApplication buses size * self tableLineHeight
]

{ #category : #actions }
MiBrowserPresenter >> activateItem: aBus [
	model followBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> deactivateItem: aBus [
	model unfollowBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> highlightWindow [
	model window beep
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
