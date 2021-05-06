Class {
	#name : #MiQueryBuilderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'builderLayout',
		'presenters',
		'parentBrowser',
		'currentQuery'
	],
	#category : #'Midas-NewQueriesBrowser-Subpresenters'
}

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> currentQuery [

	^ currentQuery
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeFirstQueryCreation [

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          (MiNewQueryCreationPresenter on: self).
	presenters add: queryCreationPresenter
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	presenters := OrderedCollection new.
	self initializeFirstQueryCreation.
	self updateLayout
]

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aBrowserPresenter [

	parentBrowser := aBrowserPresenter.
	currentQuery := parentBrowser currentQuery
]

{ #category : #initialization }
MiQueryBuilderPresenter >> updateLayout [

	builderLayout := SpBoxLayout newTopToBottom.
	presenters do: [ :aQueryCreationPresenter | 
		builderLayout add: aQueryCreationPresenter ].
	self layout: builderLayout.
	"Update method updates the presenter layout"
	self update
]
