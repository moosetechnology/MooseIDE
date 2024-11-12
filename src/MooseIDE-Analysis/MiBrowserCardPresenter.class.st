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
		register: (MiPropagateCommand forSpecContext: aPresenter browser);
		register: (MiInspectCommand forSpecContext: aPresenter browser);
		register: (MiAnalysisCloseBrowserCommand forSpecContext: aPresenter);
		register: (MiHelpCommand forSpecContext: aPresenter browser)
]

{ #category : #accessing }
MiBrowserCardPresenter >> browser [

	^ browser
]

{ #category : #'as yet unclassified' }
MiBrowserCardPresenter >> closeBrowser [

	owner items: (owner items copyWithout: self)
]

{ #category : #layout }
MiBrowserCardPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  vAlignCenter;
		  add: titleLabel;
		  add: buttons expand: false;
		  yourself
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
		           beIcons
]

{ #category : #'accessing - model' }
MiBrowserCardPresenter >> setModelBeforeInitialization: aBrowser [

	browser := aBrowser
]
