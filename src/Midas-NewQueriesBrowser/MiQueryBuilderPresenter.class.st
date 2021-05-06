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
	presenters add: queryCreationPresenter.
	builderLayout add: queryCreationPresenter.
	self initializeLayout
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeLayout [

	self layout: builderLayout.
	"Update method updates the presenter layout"
	self update
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	builderLayout := SpBoxLayout newTopToBottom.
	presenters := OrderedCollection new.
	self initializeFirstQueryCreation
]

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aBrowserPresenter [

	parentBrowser := aBrowserPresenter.
	currentQuery := parentBrowser currentQuery
]

{ #category : #initialization }
MiQueryBuilderPresenter >> updateLayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom.
	presenters do: [ :aQueryCreationPresenter | 
		newLayout add: aQueryCreationPresenter ].
	builderLayout := newLayout.
	self layout: builderLayout
]
