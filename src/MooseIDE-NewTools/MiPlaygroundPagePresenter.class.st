"
I am a custom `StPlaygroundPagePresenter`.
I have a specific toolbar button to select a model and `MiPlaygroundPagePresenter>>#addModelExpression:` to add an expression to my code.
"
Class {
	#name : 'MiPlaygroundPagePresenter',
	#superclass : 'StPlaygroundPagePresenter',
	#category : 'MooseIDE-NewTools-Playground',
	#package : 'MooseIDE-NewTools',
	#tag : 'Playground'
}

{ #category : 'adding' }
MiPlaygroundPagePresenter >> addModelExpression: anExpression [

	text insertAndSelectAfterCurrentSelection: anExpression
]

{ #category : 'private' }
MiPlaygroundPagePresenter >> addMooseToolbarCommandsTo: aGroup [

	MiWindowPresenter
		buildCommandsGroupWith: self playgroundBrowser
		forRoot: aGroup
]

{ #category : 'accessing' }
MiPlaygroundPagePresenter >> application [
	"This allows the playground to use the StPharoApplication instead of the Moose-specific application.
	We do not want the native windows to open silently as Moose windows."

	^ application
]

{ #category : 'public access' }
MiPlaygroundPagePresenter >> evaluate [

	^ self text
		  evaluate: self selectedTextOrLine
		  onCompileError: [ :e | ^ self ]
		  onError: [ :e | e pass ]
]

{ #category : 'initialization' }
MiPlaygroundPagePresenter >> initializePresenters [

	super initializePresenters.
	text interactionModel: MiPlaygroundInteractionModel new
]

{ #category : 'private' }
MiPlaygroundPagePresenter >> menuActionsFor: aCodePresenter [

	^ CmCommandGroup forSpec
		  beRoot;
		  register: ((CmCommandGroup named: 'Extra') asSpecGroup
				   beDisplayedAsGroup;
				   register: (StEvaluateCommand forSpecContext: self);
				   register:
					   ((MiInspectCommand forSpecContext: self playgroundBrowser)
						    name: 'Inspect in Moose');
				   register:
					   (MiPropagateCommand forSpecContext: self playgroundBrowser);
				   yourself);
		  register: (aCodePresenter rootCommandsGroup name: 'Code');
		  in: [ :this |
			  self addMenuEditionCommandsTo: this presenter: aCodePresenter ];
		  in: [ :this | self addMenuCommandsTo: this ];
		  register: ((CmCommandGroup named: 'Playground') asSpecGroup
				   register: ((CmCommandGroup named: 'Base options') asSpecGroup
						    beDisplayedAsGroup;
						    in: [ :this | self addToolbarCommandsTo: this ];
						    yourself);
				   register:
					   ((CmCommandGroup named: 'Miscelaneous options') asSpecGroup
						    beDisplayedAsGroup;
						    register: (StShowLineNumbersCommand forSpecContext: self);
						    yourself);
				   yourself);
		  yourself
]

{ #category : 'accessing' }
MiPlaygroundPagePresenter >> playgroundBrowser [

	^ self owner ifNotNil: [ :presenter |
		  | root |
		  root := presenter root.
		  root isWindowPresenter
			  ifFalse: [ root ]
			  ifTrue: [ root presenter ] ]
]

{ #category : 'private' }
MiPlaygroundPagePresenter >> toolbarActions [

	^ CmCommandGroup forSpec
		  in: [ :this |
			  self addToolbarCommandsTo: this.
			  self addMooseToolbarCommandsTo: this ];
		  yourself
]

{ #category : 'actions' }
MiPlaygroundPagePresenter >> updateToolbar [

	toolbar fillWith: self toolbarActions
]
