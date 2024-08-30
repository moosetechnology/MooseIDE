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

{ #category : #'public access' }
MiPlaygroundPagePresenter >> evaluate [

	^ self text
		  evaluate: self selectedTextOrLine
		  onCompileError: [ :e | ^ self ]
		  onError: [ :e | e pass ]
]

{ #category : #private }
MiPlaygroundPagePresenter >> menuActionsFor: aCodePresenter [

	^ CmCommandGroup forSpec
		  beRoot;
		  register: ((CmCommandGroup named: 'Extra') asSpecGroup
				   beDisplayedAsGroup;
				   register: (StEvaluateCommand forSpecContext: self);
				   register:
					   (MiInspectCommand forSpecContext: self playgroundBrowser);
				   register:
					   (MiPropagateCommand forSpecContext: self playgroundBrowser);
				   yourself);
		  register: (aCodePresenter rootCommandsGroup name: 'Code');
		  register: (aCodePresenter editionCommandsGroup name: 'Edition');
		  register: ((CmCommandGroup named: 'Playground') asSpecGroup
				   register: ((CmCommandGroup named: 'Base options') asSpecGroup
						    beDisplayedAsGroup;
						    register: (StPlaygroundPublishCommand forSpecContext: self);
						    register: (StPlaygroundBindingsCommand forSpecContext: self);
						    register: (StPlaygroundPagesCommand forSpecContext: self);
						    yourself);
				   register:
					   ((CmCommandGroup named: 'Miscelaneous options') asSpecGroup
						    beDisplayedAsGroup;
						    register: (StShowLineNumbersCommand forSpecContext: self);
						    yourself);
				   yourself);
		  yourself
]

{ #category : #accessing }
MiPlaygroundPagePresenter >> playgroundBrowser [

	^ self owner ifNotNil: [ :presenter |
		  | root |
		  root := presenter root.
		  root isWindowPresenter
			  ifFalse: [ root ]
			  ifTrue: [ root presenter ] ]
]
