Class {
	#name : #MiMidasBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'mainPresenter'
	],
	#category : #'Midas-Core-Application'
}

{ #category : #height }
MiMidasBrowser class >> browsersTabHeight [
	^ self currentApplication browsers size * self toolbarHeight
		+
			(self currentApplication browsers size
				* (1 max: self currentApplication buses size)
				* self tableLineHeight)
]

{ #category : #height }
MiMidasBrowser class >> busesTabHeight [
	^ self currentApplication buses size * self toolbarHeight
		+
			(self currentApplication buses size
				* (1 max: self currentApplication browsers size)
				* self tableLineHeight)
]

{ #category : #specs }
MiMidasBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #mainPresenter;
		yourself
]

{ #category : #height }
MiMidasBrowser class >> emptyBrowserHeight [
	^ 75
]

{ #category : #height }
MiMidasBrowser class >> height [
	^ (self busesTabHeight max: self browsersTabHeight)
		+ self emptyBrowserHeight
]

{ #category : #specs }
MiMidasBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #specs }
MiMidasBrowser class >> title [
	^ 'Buses and Browsers'
]

{ #category : #initialization }
MiMidasBrowser >> browsersPage [
	^ self newNotebookPage
		title: 'Browsers';
		presenterProvider: [ self newComponentList
				items:
					(self application browsers asOrderedCollection
						collect: [ :browser | MiBrowserPresenter owner: self on: browser ]) ];
		yourself
]

{ #category : #initialization }
MiMidasBrowser >> busesPage [
	^ self newNotebookPage
		title: 'Buses';
		presenterProvider: [ self newComponentList
				propagateNaturalHeight: true;
				items:
					(self application buses asOrderedCollection
						collect: [ :bus | MiBusPresenter owner: self on: bus ]) ];
		yourself
]

{ #category : #initialization }
MiMidasBrowser >> initializePresenters [
	super initializePresenters.
	mainPresenter := self newNotebook
		addPage: self busesPage;
		addPage: self browsersPage;
		yourself
]

{ #category : #initialization }
MiMidasBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 500 @ self class height
]
