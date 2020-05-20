Class {
	#name : #MiLogBrowser,
	#superclass : #MiPresenter,
	#category : #'Midas-Core-Browser'
}

{ #category : #accessing }
MiLogBrowser >> logger [
	^ self application logger
]
