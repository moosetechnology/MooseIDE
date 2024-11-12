Class {
	#name : #MiNullBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Analysis'
}

{ #category : #testing }
MiNullBrowser >> canFollowEntity: anObject [

	^ false
]

{ #category : #layout }
MiNullBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #mainPresenter;
		  yourself
]

{ #category : #initialization }
MiNullBrowser >> initializePresenters [

	super initializePresenters.
	mainPresenter := self newNullPresenter
]

{ #category : #accessing }
MiNullBrowser >> miSelectedItem [

	^ nil
]

{ #category : #accessing }
MiNullBrowser >> miSelectedItemToPropagate [

	^ nil
]
