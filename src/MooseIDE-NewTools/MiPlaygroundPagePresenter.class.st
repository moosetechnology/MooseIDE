Class {
	#name : #MiPlaygroundPagePresenter,
	#superclass : #StPlaygroundPagePresenter,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #adding }
MiPlaygroundPagePresenter >> addModelExpression: anExpression [

	text insertAndSelectAfterCurrentSelection: anExpression
]

{ #category : #'instance creation' }
MiPlaygroundPagePresenter >> toolbarActions [

	^ super toolbarActions
		  register:
			  (MiPlaygroundInstalledModelsCommand forSpecContext: self);
		  yourself
]
