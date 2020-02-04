Class {
	#name : #MiLogBrowser,
	#superclass : #MiPresenter,
	#category : #'Midas-Browser'
}

{ #category : #accessing }
MiLogBrowser >> logger [
	^ self application logger
]
