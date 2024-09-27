Class {
	#name : #MiBrowserCardPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'browser',
		'titleLabel',
		'buttons'
	],
	#category : #'MooseIDE-Analysis'
}

{ #category : #commands }
MiBrowserCardPresenter class >> buildCommandsGroupWith: aPresenter forRoot: rootCommandGroup [

	rootCommandGroup
		register: (MiPropagateCommand forSpecContext: aPresenter);
		register: (MiInspectCommand forSpecContext: aPresenter)
]

{ #category : #accessing }
MiBrowserCardPresenter >> browser [

	^ browser
]

{ #category : #toolbar }
MiBrowserCardPresenter >> defaultCommandsContext [

	^ browser
]

{ #category : #layout }
MiBrowserCardPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  vAlignCenter;
		  add: titleLabel;
		  add: buttons expand: false;
		  yourself
]

{ #category : #actions }
MiBrowserCardPresenter >> helpPopoverSource [

	^ buttons items last
]

{ #category : #actions }
MiBrowserCardPresenter >> helpText [

	^ browser helpText
]

{ #category : #initialization }
MiBrowserCardPresenter >> initializePresenters [

	super initializePresenters.
	titleLabel := self newLabel
		              label: browser title;
		              help: browser miSelectedItem asString;
		              yourself.

	buttons := self newToolbar
		           fillWith: self rootCommandsGroup;
		           add:
			           (MiHelpCommand forSpecContext: self)
				           beDisplayedOnRightSide buildPresenter;
		           beIcons
]

{ #category : #'accessing - model' }
MiBrowserCardPresenter >> setModelBeforeInitialization: aBrowser [

	browser := aBrowser
]

{ #category : #actions }
MiBrowserCardPresenter >> showHelp [

	^ super showHelp bePositionRight
]
