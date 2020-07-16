Class {
	#name : #MiMidasItemPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'toolbar',
		'model',
		'table'
	],
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiMidasItemPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolbar height: self toolbarHeight;
		add: #table height: self tableHeight;
		yourself
]

{ #category : #specs }
MiMidasItemPresenter class >> tableHeight [
	^ self subclassResponsibility
]

{ #category : #initialization }
MiMidasItemPresenter >> initializePresenters [
	super initializePresenters.
	toolbar := self newLabel label: self toolbarLabel.
	self initializeTable
]

{ #category : #initialization }
MiMidasItemPresenter >> initializeTable [
	table := self newTable
		addColumn:
			((SpCheckBoxTableColumn evaluated: self tableCheckBoxEvaluation)
				width: 20;
				yourself);
		addColumn: (SpStringTableColumn evaluated: self tableStringEvaluation);
		items: self tableItems;
		yourself
]

{ #category : #'accessing model' }
MiMidasItemPresenter >> setModelBeforeInitialization: aBus [
	model := aBus
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
