"
I am a custom `StPlaygroundPagePresenter`.
I have a specific toolbar button to select a model and `MiPlaygroundPagePresenter>>#addModelExpression:` to add an expression to my code.
"
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
