Class {
	#name : #MiMidasItemPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'table',
		'nameLabel'
	],
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiMidasItemPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: self toolbarLayout height: self toolbarHeight;
		add: #table height: self tableHeight;
		yourself
]

{ #category : #specs }
MiMidasItemPresenter class >> tableHeight [
	^ self subclassResponsibility
]

{ #category : #specs }
MiMidasItemPresenter class >> toolbarLayout [
	self subclassResponsibility
]

{ #category : #actions }
MiMidasItemPresenter >> activateItem: aBusOrBrowser [
	self subclassResponsibility
]

{ #category : #actions }
MiMidasItemPresenter >> deactivateItem: aBusOrBrowser [
	self subclassResponsibility
]

{ #category : #initialization }
MiMidasItemPresenter >> initializePresenters [
	super initializePresenters.
	nameLabel := self newLabel label: self toolbarLabel.
	self initializeTable
]

{ #category : #initialization }
MiMidasItemPresenter >> initializeTable [

	table := self newTable
		         addColumn:
			         ((SpCheckBoxTableColumn evaluated:
					           self tableCheckBoxEvaluation)
				          onActivation: [ :aBusOrBrowser | 
					          self activateItem: aBusOrBrowser ];
				          onDeactivation: [ :aBusOrBrowser | 
					          self deactivateItem: aBusOrBrowser ];
				          width: 20;
				          yourself);
		         addColumn:
		         (SpStringTableColumn evaluated: self tableStringEvaluation);
		         items: self tableItems;
		         yourself
]

{ #category : #'accessing model' }
MiMidasItemPresenter >> setModelBeforeInitialization: aBusOrBrowser [
	model := aBusOrBrowser
]

{ #category : #settings }
MiMidasItemPresenter >> tableCheckBoxEvaluation [
	^ self subclassResponsibility
]

{ #category : #settings }
MiMidasItemPresenter >> tableItems [
	^ self subclassResponsibility
]

{ #category : #settings }
MiMidasItemPresenter >> tableStringEvaluation [
	^ self subclassResponsibility
]

{ #category : #settings }
MiMidasItemPresenter >> toolbarLabel [
	^ self subclassResponsibility
]
